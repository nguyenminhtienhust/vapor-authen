import Vapor

struct RegisterRequest: Content {
    let fullName: String
    let phone: String
    let password: String
    let confirmPassword: String
}

extension RegisterRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("fullName", as: String.self, is: .count(3...))
        validations.add("phone", as: String.self, is: .count(10...11))
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension User {
    convenience init(from register: RegisterRequest, hash: String) throws {
        self.init(fullName: register.fullName, phone: register.phone, passwordHash: hash)
    }
}


struct CreateUserRequest : Content {
    let fullName: String
    let phone: String
    let password: String
    let isActive: Bool
}

extension CreateUserRequest : Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("fullName", as: String.self, is: .count(3...))
        validations.add("phone", as: String.self, is: .count(10...11))
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension User {
    convenience init(from register: CreateUserRequest, hash: String) throws {
        self.init(fullName: register.fullName, phone: register.phone, passwordHash: hash,isActive: register.isActive)
    }
}

