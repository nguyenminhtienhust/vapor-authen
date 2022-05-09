import Vapor

struct SendPhoneVerificationRequest: Content {
    let phone: String
}
