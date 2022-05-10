import Vapor
import Queues
import AsyncHTTPClient

struct UserVerifier {
    let emailTokenRepository: UserTokenRepository
    let config: AppConfig
    let queue: Queue
    let eventLoop: EventLoop
    let generator: RandomGenerator
    
    func verify(for user: User) async throws {
        do {
            let token = generator.generate(bits: 256)
            let emailToken = try UserPhoneToken(userID: user.requireID(), token: SHA256.hash(token))
            let verifyUrl = try await url(token: token)
            try await emailTokenRepository.create(emailToken)
            //self.queue.dispatch(EmailJob.self, .init(VerificationEmail(verifyUrl: verifyUrl), to: user.email))
        } catch {
            return 
        }
        return
    }
    
    private func url(token: String) async throws -> String {
        #"\#(config.apiURL)/auth/email-verification?token=\#(token)"#
    }
}

extension Application {
    var userVerifier: UserVerifier {
        .init(emailTokenRepository: self.repositories.emailTokens, config: self.config, queue: self.queues.queue, eventLoop: eventLoopGroup.next(), generator: self.random)
    }
}

extension Request {
    var userVerifier: UserVerifier {
        .init(emailTokenRepository: self.emailTokens, config: application.config, queue: self.queue, eventLoop: eventLoop, generator: self.application.random)
    }
}

