import Vapor
import Fluent
import AsyncHTTPClient

struct AuthenticationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("auth") { auth in
            auth.post("register", use: register)
            auth.post("login", use: login)
            auth.post("create", use: createUser)
            
            auth.group("phone-verification") { emailVerificationRoutes in
                emailVerificationRoutes.post("", use: sendEmailVerification)
                emailVerificationRoutes.get("", use: verifyEmail)
            }
            
            auth.group("reset-password") { resetPasswordRoutes in
                resetPasswordRoutes.post("", use: resetPassword)
                resetPasswordRoutes.get("verify", use: verifyResetPasswordToken)
            }
            auth.post("recover", use: recoverAccount)
            
            auth.post("accessToken", use: refreshAccessToken)
            
            auth.group(UserAuthenticator()) { authenticated in
                authenticated.get("me", use: getCurrentUser)
            } 
        }
    }
    
    private func register(_ req: Request) async throws -> HTTPStatus {
        try RegisterRequest.validate(content: req)
        let registerRequest = try req.content.decode(RegisterRequest.self)
        guard registerRequest.password == registerRequest.confirmPassword else {
            throw AuthenticationError.passwordsDontMatch
        }
        let hash = try await req.password.hash(registerRequest.password)
        let user = try User(from: registerRequest, hash: hash)
        try await req.users.create(user)
        try await req.userVerifier.verify(for: user)
        return HTTPStatus.ok
    }
    
    private func createUser(_ req: Request) async throws -> HTTPStatus {
        try CreateUserRequest.validate(content: req)
        let createRequest = try req.content.decode(CreateUserRequest.self)
        let hash = try await req.password.hash(createRequest.password)
        let user = try User(from: createRequest, hash: hash)
        try await req.users.create(user)
        try await req.userVerifier.verify(for: user)
        return HTTPStatus.ok
    }
    
    private func login(_ req: Request) async throws -> LoginResponse {
        try LoginRequest.validate(content: req)
        let loginRequest = try req.content.decode(LoginRequest.self)
        
        if let user = try await req.users.find(phone: loginRequest.phone) {
            if !user.isActive {
                throw AuthenticationError.userNotActive
            }else{
                let status = try await req.password.verify(loginRequest.password, created: user.passwordHash)
                if !status {
                    throw AuthenticationError.invalidEmailOrPassword
                }else{
                    let token = req.random.generate(bits: 256)
                    return try LoginResponse(user: UserDTO(from: user), accessToken: req.jwt.sign(Payload(with: user)), refreshToken: token)
                }
            }
        }else{
            throw AuthenticationError.userNotFound
        }
    }
    
    private func refreshAccessToken(_ req: Request) async throws -> AccessTokenResponse {
        let accessTokenRequest = try req.content.decode(AccessTokenRequest.self)
        let hashedRefreshToken = SHA256.hash(accessTokenRequest.refreshToken)
        if let refreshToken = try await req.refreshTokens.find(token: hashedRefreshToken){
           try await req.refreshTokens.delete(refreshToken)
            if refreshToken.expiresAt > Date() {
                if let user = try await req.users.find(id: refreshToken.$user.id) {
                    let token = req.random.generate(bits: 256)
                    let refreshToken = try RefreshToken(token: SHA256.hash(token), userID: user.requireID())
                    let payload = try Payload(with: user)
                    let accessToken = try req.jwt.sign(payload)
                    try await req.refreshTokens
                        .create(refreshToken)
                    return AccessTokenResponse(refreshToken: token, accessToken: accessToken)
                }else{
                    throw AuthenticationError.refreshTokenOrUserNotFound
                }
            }else{
                throw AuthenticationError.refreshTokenHasExpired
            }

        }else{
            throw AuthenticationError.refreshTokenOrUserNotFound
        }
    }
    
    private func getCurrentUser(_ req: Request) async throws -> UserDTO {
        let payload = try req.auth.require(Payload.self)
        if let user = try await req.users.find(id: payload.userID) {
            return UserDTO(from: user)
        }else{
            throw AuthenticationError.userNotFound
        }
    }
    
    private func verifyEmail(_ req: Request) async throws -> HTTPStatus {
        let token = try req.query.get(String.self, at: "token")
        let hashedToken = SHA256.hash(token)
        if let user = try await req.emailTokens.find(token: hashedToken) {
            try await req.emailTokens.delete(user)
            if user.expiresAt > Date() {
                try await req.users.set(\.$isActive, to: true, for: user.$user.id)
                return HTTPStatus.ok
            }else{
                throw AuthenticationError.emailTokenHasExpired
            }
        }else{
            throw AuthenticationError.emailTokenNotFound
        }
    }
    
    private func resetPassword(_ req: Request) async throws -> HTTPStatus {
        let resetPasswordRequest = try req.content.decode(ResetPasswordRequest.self)
        return HTTPStatus.ok
//        return req.users
//            .find(email: resetPasswordRequest.email)
//            .flatMap {
//                if let user = $0 {
//                    return req.passwordResetter
//                        .reset(for: user)
//                        .transform(to: .noContent)
//                } else {
//                    return req.eventLoop.makeSucceededFuture(.noContent)
//                }
//        }
    }
    
    private func verifyResetPasswordToken(_ req: Request) async throws -> HTTPStatus {
        let token = try req.query.get(String.self, at: "token")
        
        let hashedToken = SHA256.hash(token)
        return HTTPStatus.ok

//        return req.passwordTokens
//            .find(token: hashedToken)
//            .unwrap(or: AuthenticationError.invalidPasswordToken)
//            .flatMap { passwordToken in
//                guard passwordToken.expiresAt > Date() else {
//                    return req.passwordTokens
//                        .delete(passwordToken)
//                        .transform(to: req.eventLoop
//                            .makeFailedFuture(AuthenticationError.passwordTokenHasExpired)
//                    )
//                }
//
//                return req.eventLoop.makeSucceededFuture(.noContent)
//        }
    }
    
    private func recoverAccount(_ req: Request) async throws -> HTTPStatus {
        try RecoverAccountRequest.validate(content: req)
        let content = try req.content.decode(RecoverAccountRequest.self)
        
        guard content.password == content.confirmPassword else {
            throw AuthenticationError.passwordsDontMatch
        }
        
        let hashedToken = SHA256.hash(content.token)
        return HTTPStatus.ok

//        return req.passwordTokens
//            .find(token: hashedToken)
//            .unwrap(or: AuthenticationError.invalidPasswordToken)
//            .flatMap { passwordToken -> EventLoopFuture<Void> in
//                guard passwordToken.expiresAt > Date() else {
//                    return req.passwordTokens
//                        .delete(passwordToken)
//                        .transform(to: req.eventLoop
//                            .makeFailedFuture(AuthenticationError.passwordTokenHasExpired)
//                    )
//                }
//
//                return req.password
//                    .async
//                    .hash(content.password)
//                    .flatMap { digest in
//                        req.users.set(\.$passwordHash, to: digest, for: passwordToken.$user.id)
//                }
//                .flatMap { req.passwordTokens.delete(for: passwordToken.$user.id) }
//        }
//        .transform(to: .noContent)
    }
    
    private func sendEmailVerification(_ req: Request) async throws -> HTTPStatus {
        let content = try req.content.decode(SendPhoneVerificationRequest.self)
        if let user = try await req.users.find(phone: content.phone) {
            if user.isActive {
                try await req.userVerifier.verify(for: user)
                return HTTPStatus.ok
            }else{
                return HTTPStatus.noContent
            }
        }else{
            return HTTPStatus.noContent
        }
    }
}

extension PasswordHasher {
    public func hash(_ password: String) async throws -> String {
        return try String(decoding: self.hash([UInt8](password.utf8)), as: UTF8.self)
    }

    public func verify(_ password: String, created digest: String) async throws -> Bool {
        return try self.verify(
            [UInt8](password.utf8),
            created: [UInt8](digest.utf8)
        )
    }
}
