import Vapor
import Fluent
import JWT
import JWTKit

final class User: Model, Authenticatable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "full_name")
    var fullName: String
    
    @Field(key: "phone")
    var phone: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    @Field(key: "is_admin")
    var isAdmin: Bool
    
    @Field(key: "is_active")
    var isActive: Bool
    
    init() {}
    
    init(
        id: UUID? = nil,
        fullName: String,
        phone: String,
        passwordHash: String,
        isAdmin: Bool = false,
        isActive: Bool = false
    ) {
        self.id = id
        self.fullName = fullName
        self.phone = phone
        self.passwordHash = passwordHash
        self.isAdmin = isAdmin
        self.isActive = isActive
    }
}
