@testable import App
import Fluent
import XCTVapor
import AsyncHTTPClient

final class EmailTokenRepositoryTests: XCTestCase {
    var app: Application!
    var repository: UserTokenRepository!
    var user: User!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        repository = DatabaseUserTokenRepository(database: app.db)
        try app.autoMigrate().wait()
        
        user = User(fullName: "Test", phone: "test@test.com", passwordHash: "123")
    }
    
    override func tearDownWithError() throws {
        try app.autoRevert().wait()
        app.shutdown()
    }
    
    func testCreatingEmailToken() async throws {
        try user.create(on: app.db).wait()
        let phoneToken = UserPhoneToken(userID: try user.requireID(), token: "emailToken")
        try await repository.create(phoneToken)
        let count = try await UserPhoneToken.query(on: app.db).count()
        XCTAssertEqual(count, 1)
    }
    
    func testFindingEmailTokenByToken() async throws {
        try user.create(on: app.db).wait()
        let phoneToken = UserPhoneToken(userID: try user.requireID(), token: "123")
        try await phoneToken.create(on: app.db)
        let found = try await repository.find(token: "123")
        XCTAssertNotNil(found)
    }
    
    func testDeleteEmailToken() async throws {
        try await user.create(on: app.db)
        let phoneToken = UserPhoneToken(userID: try user.requireID(), token: "123")
        try await phoneToken.create(on: app.db)
        try await repository.delete(phoneToken)
        let count = try await UserPhoneToken.query(on: app.db).count()
        XCTAssertEqual(count, 0)
    }
}
    

