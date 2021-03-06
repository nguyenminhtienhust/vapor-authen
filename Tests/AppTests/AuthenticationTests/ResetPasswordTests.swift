@testable import App
import Fluent
import XCTVapor
import Crypto

final class ResetPasswordTests: XCTestCase {
    var app: Application!
    var testWorld: TestWorld!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        self.testWorld = try TestWorld(app: app)
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testResetPassword() async throws {
//        app.randomGenerators.use(.rigged(value: "passwordtoken"))
//
//        let user = User(fullName: "Test User", phone: "test@test.com", passwordHash: "123")
//        try app.repositories.users.create(user).wait()
//
//        let resetPasswordRequest = ResetPasswordRequest(email: "test@test.com")
//        try app.test(.POST, "api/auth/reset-password", content: resetPasswordRequest, afterResponse: { res in
//            XCTAssertEqual(res.status, .noContent)
//            let passwordToken = try app.repositories.passwordTokens.find(token: SHA256.hash("passwordtoken")).wait()
//            XCTAssertNotNil(passwordToken)
//        })
    }
    
    func testResetPasswordSucceedsWithNonExistingEmail() async throws {
//        let resetPasswordRequest = ResetPasswordRequest(email: "none@test.com")
//        try app.test(.POST, "api/auth/reset-password", content: resetPasswordRequest, afterResponse: { res in
//            XCTAssertEqual(res.status, .noContent)
//            let tokenCount = try app.repositories.passwordTokens.count().wait()
//            XCTAssertEqual(tokenCount, 0)
//        })
    }
    
    func testRecoverAccount() async throws {
//        let user = User(fullName: "Test User", phone: "test@test.com", passwordHash: "oldpassword")
//        try app.repositories.users.create(user).wait()
//        let token = try PasswordToken(userID: user.requireID(), token: SHA256.hash("passwordtoken"))
//        let existingToken = try PasswordToken(userID: user.requireID(), token: "token2")
//
//        try app.repositories.passwordTokens.create(token).wait()
//        try app.repositories.passwordTokens.create(existingToken).wait()
//
//        let recoverRequest = RecoverAccountRequest(password: "newpassword", confirmPassword: "newpassword", token: "passwordtoken")
//
//        try app.test(.POST, "api/auth/recover", content: recoverRequest, afterResponse: { res in
//            XCTAssertEqual(res.status, .noContent)
//            let user = try app.repositories.users.find(id: user.requireID()).wait()!
//            try XCTAssertTrue(BCryptDigest().verify("newpassword", created: user.passwordHash))
//            let count = try app.repositories.passwordTokens.count().wait()
//            XCTAssertEqual(count, 0)
//        })
    }
    
    func testRecoverAccountWithExpiredTokenFails() async throws {
//        let token = PasswordToken(userID: UUID(), token: SHA256.hash("passwordtoken"), expiresAt: Date().addingTimeInterval(-60))
//        try app.repositories.passwordTokens.create(token).wait()
//
//        let recoverRequest = RecoverAccountRequest(password: "password", confirmPassword: "password", token: "passwordtoken")
//        try app.test(.POST, "api/auth/recover", content: recoverRequest, afterResponse: { res in
//            XCTAssertResponseError(res, AuthenticationError.passwordTokenHasExpired)
//        })
    }
    
    func testRecoverAccountWithInvalidTokenFails() async throws {
//        let recoverRequest = RecoverAccountRequest(password: "password", confirmPassword: "password", token: "sdfsdfsf")
//        try app.test(.POST, "api/auth/recover", content: recoverRequest, afterResponse: { res in
//            XCTAssertResponseError(res, AuthenticationError.invalidPasswordToken)
//        })
    }
    
    func testRecoverAccountWithNonMatchingPasswordsFail() async throws {
//        let recoverRequest = RecoverAccountRequest(password: "password", confirmPassword: "password123", token: "token")
//        try app.test(.POST, "api/auth/recover", content: recoverRequest, afterResponse: { res in
//            XCTAssertResponseError(res, AuthenticationError.passwordsDontMatch)
//        })
    }
    
    func testVerifyPasswordToken() async throws {
//        let user = User(fullName: "Test User", phone: "test@test.com", passwordHash: "123")
//        try app.repositories.users.create(user).wait()
//        let passwordToken = try PasswordToken(userID: user.requireID(), token: SHA256.hash("token"))
//        try app.repositories.passwordTokens.create(passwordToken).wait()
//
//        try app.test(.GET, "api/auth/reset-password/verify?token=token", afterResponse: { res in
//            XCTAssertEqual(res.status, .noContent)
//        })
    }
    
    func testVerifyPasswordTokenFailsWithInvalidToken() async throws {
//        try app.test(.GET, "api/auth/reset-password/verify?token=invalidtoken", afterResponse: { res in
//            XCTAssertResponseError(res, AuthenticationError.invalidPasswordToken)
//        })
    }
    
    func testVerifyPasswordTokenFailsWithExpiredToken() async throws {
//        let user = User(fullName: "Test User", phone: "test@test.com", passwordHash: "123")
//        try app.repositories.users.create(user).wait()
//        let passwordToken = try PasswordToken(userID: user.requireID(), token: SHA256.hash("token"), expiresAt: Date().addingTimeInterval(-60))
//        try app.repositories.passwordTokens.create(passwordToken).wait()
//
//        try app.test(.GET, "api/auth/reset-password/verify?token=token", afterResponse: { res in
//            XCTAssertResponseError(res, AuthenticationError.passwordTokenHasExpired)
//            let tokenCount = try app.repositories.passwordTokens.count().wait()
//            XCTAssertEqual(tokenCount, 0)
//        })
    }
}
