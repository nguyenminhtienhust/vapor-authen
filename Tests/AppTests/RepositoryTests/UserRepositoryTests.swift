@testable import App
import Fluent
import XCTVapor

final class UserRepositoryTests: XCTestCase {
    var app: Application!
    var repository: UserRepository!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        repository = DatabaseUserRepository(database: app.db)
        try app.autoMigrate().wait()
    }
    
    override func tearDownWithError() throws {
        try app.autoRevert().wait()
        app.shutdown()
    }
    
    func testCreatingUser() throws {
        let user = User(fullName: "Test User", phone: "test@test.com", passwordHash: "123")
        try repository.create(user).wait()
        
        XCTAssertNotNil(user.id)
        
        let userRetrieved = try User.find(user.id, on: app.db).wait()
        XCTAssertNotNil(userRetrieved)
    }
    
    func testDeletingUser() throws {
        let user = User(fullName: "Test User", phone: "test@test.com", passwordHash: "123")
        try user.create(on: app.db).wait()
        let count = try User.query(on: app.db).count().wait()
        XCTAssertEqual(count, 1)
        
        try repository.delete(id: user.requireID()).wait()
        let countAfterDelete = try User.query(on: app.db).count().wait()
        XCTAssertEqual(countAfterDelete, 0)
    }
    
    func testGetAllUsers() throws {
        let user = User(fullName: "Test User", phone: "test@test.com", passwordHash: "123")
        let user2 = User(fullName: "Test User 2", phone: "test2@test.com", passwordHash: "123")
        
        try user.create(on: app.db).wait()
        try user2.create(on: app.db).wait()
        
        let users = try repository.all().wait()
        XCTAssertEqual(users.count, 2)
    }
    
    func testFindUserById() throws {
        let user = User(fullName: "Test User", phone: "test@test.com", passwordHash: "123")
        try user.create(on: app.db).wait()
        
        let userFound = try repository.find(id: user.requireID()).wait()
        XCTAssertNotNil(userFound)
    }
    
    func testSetFieldValue() throws {
        let user = User(fullName: "Test User", phone: "test@test.com", passwordHash: "123", isActive: false)
        try user.create(on: app.db).wait()
        
        try repository.set(\.$isActive, to: true, for: user.requireID()).wait()
        
        let updatedUser = try User.find(user.id!, on: app.db).wait()
        XCTAssertEqual(updatedUser!.isActive, true)
    }
}
    

