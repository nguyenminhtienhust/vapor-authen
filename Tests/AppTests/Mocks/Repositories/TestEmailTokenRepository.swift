@testable import App
import Vapor

class TestEmailTokenRepository {//: EmailTokenRepository, TestRepository {
    var tokens: [UserPhoneToken]
    var eventLoop: EventLoop
    
    init(tokens: [UserPhoneToken] = [], eventLoop: EventLoop) {
        self.tokens = tokens
        self.eventLoop = eventLoop
    }
    
    func find(token: String) -> EventLoopFuture<UserPhoneToken?> {
        let token = tokens.first(where: { $0.token == token })
        return eventLoop.makeSucceededFuture(token)
    }
    
    func create(_ emailToken: UserPhoneToken) -> EventLoopFuture<Void> {
        tokens.append(emailToken)
        return eventLoop.makeSucceededFuture(())
    }
    
    func delete(_ emailToken: UserPhoneToken) -> EventLoopFuture<Void> {
        tokens.removeAll(where: { $0.id == emailToken.id })
        return eventLoop.makeSucceededFuture(())
    }
    
    
    func find(userID: UUID) -> EventLoopFuture<UserPhoneToken?> {
        let token = tokens.first(where: { $0.$user.id == userID })
        return eventLoop.makeSucceededFuture(token)
    }
}
