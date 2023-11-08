import Foundation

let AccessKey = "your_Access_Key"
let SecretKey = "your_Secret_Key"
let RedirectURI = "your_Redirect_URI"
let AccessScope = "public+read_user+write_likes"

let DefaultBaseURL = "https://api.unsplash.com"
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
let PhotoBaseURLString = "https://api.unsplash.com/photos"
let DefaultApiBaseURLString = "https://api.unsplash.com"
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
                                 defaultBaseURL: DefaultBaseURL,
                                 photoBaseURLString: PhotoBaseURLString,
                                 defaultApiBaseURLString: DefaultApiBaseURLString,
                                 baseAuthTokenPath: BaseAuthTokenPath,
                                 bearerToken: BearerToken)
    }
}
