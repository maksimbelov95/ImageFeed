import Foundation

let AccessKey = "UZ45hIGtRsVO2y0XXnBx_pB8PGhp4fGvHLt6cxeL3BM"
let SecretKey = "szSRnbtDHe3fGcLkdgB3tmkqEprP9RhQ5naONjuGVvk"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

let BaseURLString = "https://unsplash.com"
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
let DefaultApiBaseURLString = "https://api.unsplash.com"
let PhotoBaseURLString = "https://api.unsplash.com/photos"
let BaseAuthTokenPath = "/oauth/token"

let BearerToken = "bearerToken"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    
    let defaultBaseURL: String
    let authURLString: String
    let photoBaseURLString: String
    let defaultApiBaseURLString: String
    let baseAuthTokenPath: String
    
    let bearerToken: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: String, photoBaseURLString: String, defaultApiBaseURLString: String, baseAuthTokenPath: String, bearerToken: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
        self.photoBaseURLString = photoBaseURLString
        self.defaultApiBaseURLString = defaultApiBaseURLString
        self.baseAuthTokenPath = baseAuthTokenPath
        self.bearerToken = bearerToken
    }
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 authURLString: UnsplashAuthorizeURLString,
                                 defaultBaseURL: BaseURLString,
                                 photoBaseURLString: PhotoBaseURLString,
                                 defaultApiBaseURLString: DefaultApiBaseURLString,
                                 baseAuthTokenPath: BaseAuthTokenPath,
                                 bearerToken: BearerToken)
    }
}
