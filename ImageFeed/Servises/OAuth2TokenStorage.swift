import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: AuthConfiguration.standard.bearerToken)
        }
        set {
            guard let newValue = newValue else{return}
            keychainWrapper.set(newValue, forKey: AuthConfiguration.standard.bearerToken)
        }
    }
}
