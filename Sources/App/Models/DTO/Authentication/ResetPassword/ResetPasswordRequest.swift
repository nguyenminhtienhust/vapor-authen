import Vapor

struct ResetPasswordRequest: Content {
    let phone: String
}

extension ResetPasswordRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("phone", as: String.self, is: .alphanumeric)
    }
}
