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
        validations.add("phone", as: String.self, is: .alphanumeric)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension User {
    convenience init(from register: RegisterRequest, hash: String) throws {
        self.init(fullName: register.fullName, phone: register.phone, passwordHash: hash)
    }
}
