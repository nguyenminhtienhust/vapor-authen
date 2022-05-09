import Vapor
import Fluent
import AsyncHTTPClient

protocol UserRepository: Repository {
    func create(_ user: User) async throws
    func delete(id: UUID) async throws
    func all() async throws -> [User]
    func find(id: UUID?) async throws -> User?
    func find(phone: String) async throws -> User?
    func set<Field>(_ field: KeyPath<User, Field>, to value: Field.Value, for userID: UUID) async throws -> Void where Field: QueryableProperty, Field.Model == User
    func count() async throws -> Int
}

struct DatabaseUserRepository: UserRepository, DatabaseRepository {
    let database: Database
    
    func create(_ user: User) async throws{
        return try await user.create(on: database)
    }
    
    func delete(id: UUID) async throws{
        return try await User.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func all() async throws -> [User] {
        return try await User.query(on: database).all()
    }
    
    func find(id: UUID?) async throws -> User? {
        return try await User.find(id, on: database)
    }
    
    func find(phone: String) async throws -> User? {
        return try await User.query(on: database)
            .filter(\.$phone == phone)
            .first()
    }
    
    func set<Field>(_ field: KeyPath<User, Field>, to value: Field.Value, for userID: UUID) async throws
        where Field: QueryableProperty, Field.Model == User
    {
        return try await User.query(on: database)
            .filter(\.$id == userID)
            .set(field, to: value)
            .update()
    }
    
    func count() async throws -> Int {
        return try await User.query(on: database).count()
    }
}

extension Application.Repositories {
    var users: UserRepository {
        guard let storage = storage.makeUserRepository else {
            fatalError("UserRepository not configured, use: app.userRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (UserRepository)) {
        storage.makeUserRepository = make
    }
}



