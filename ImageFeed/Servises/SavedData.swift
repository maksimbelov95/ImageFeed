import Foundation

final class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            return userDefaults.string(forKey: "token")
        }
        set {
            userDefaults.set(newValue, forKey: "token")
        }
    }
}
