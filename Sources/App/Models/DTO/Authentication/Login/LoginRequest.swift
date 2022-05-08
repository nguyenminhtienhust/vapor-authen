import Vapor

struct LoginRequest: Content {
    let phone: String
    let password: String
}

extension LoginRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("phone", as: String.self, is: .alphanumeric)
        validations.add("password", as: String.self, is: !.empty)
    }
}
