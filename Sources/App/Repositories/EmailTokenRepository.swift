import Vapor
import Fluent
import AsyncHTTPClient

protocol UserTokenRepository: Repository {
    func find(token: String) async throws -> UserPhoneToken?
    func create(_ userToken: UserPhoneToken) async throws
    func delete(_ userToken: UserPhoneToken) async throws
    func find(userID: UUID) async throws -> UserPhoneToken?
}

struct DatabaseUserTokenRepository: UserTokenRepository, DatabaseRepository {
    let database: Database
    
    func find(token: String) async throws -> UserPhoneToken? {
        return try await UserPhoneToken.query(on: database)
            .filter(\.$token == token)
            .first()
    }
    
    func create(_ userPhoneToken: UserPhoneToken) async throws {
        return try await userPhoneToken.create(on: database)
    }
    
    func delete(_ userPhoneToken: UserPhoneToken) async throws {
        return try await userPhoneToken.delete(on: database)
    }
    
    func find(userID: UUID) async throws -> UserPhoneToken? {
        try await UserPhoneToken.query(on: database)
            .filter(\.$user.$id == userID)
            .first()
    }
}

extension Application.Repositories {
    var emailTokens: UserTokenRepository {
        guard let factory = storage.makeEmailTokenRepository else {
            fatalError("EmailToken repository not configured, use: app.repositories.use")
        }
        return factory(app)
    }
    
    func use(_ make: @escaping (Application) -> (UserTokenRepository)) {
        storage.makeEmailTokenRepository = make
    }
}
