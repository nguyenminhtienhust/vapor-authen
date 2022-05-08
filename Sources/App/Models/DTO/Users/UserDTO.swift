import Vapor

struct UserDTO: Content {
    let id: UUID?
    let fullName: String
    let phone: String
    let isAdmin: Bool
    
    init(id: UUID? = nil, fullName: String, phone: String, isAdmin: Bool) {
        self.id = id
        self.fullName = fullName
        self.phone = phone
        self.isAdmin = isAdmin
    }
    
    init(from user: User) {
        self.init(id: user.id, fullName: user.fullName, phone: user.phone, isAdmin: user.isAdmin)
    }
}


