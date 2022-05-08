import Vapor

struct AppConfig {
    let frontendURL: String
    let apiURL: String
    //let noReplyEmail: String
    
    static var environment: AppConfig {
        if let frontendURL = Environment.get("https://tudienthoai.com") {
            if let apiURL = Environment.get("http://188.166.247.59:9999/documents") {
                return .init(frontendURL: frontendURL, apiURL: apiURL)//, noReplyEmail: noReplyEmail)
            }else{
                return .init(frontendURL: "frontendURL", apiURL: "apiURL")//, noReplyEmail: noReplyEmail)

            }
        }else{
            return .init(frontendURL: "frontendURL", apiURL: "apiURL")//, noReplyEmail: noReplyEmail)

        }
        
//        guard
//            let frontendURL = Environment.get("https://tudienthoai.com"),
//            let apiURL = Environment.get("http://188.166.247.59:9999/documents")//,
//                //let noReplyEmail = Environment.get("http://nguyenminhtien.hust@gmail.com")
//        else {
//            //fatalError("Please add app configuration to environment variables")
//            print("testing")
//        }
        
    }
}

extension Application {
    struct AppConfigKey: StorageKey {
        typealias Value = AppConfig
    }
    
    var config: AppConfig {
        get {
            storage[AppConfigKey.self] ?? .environment
        }
        set {
            storage[AppConfigKey.self] = newValue
        }
    }
}
