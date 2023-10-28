import UIKit
enum Constants{
    static let accessKey = "UZ45hIGtRsVO2y0XXnBx_pB8PGhp4fGvHLt6cxeL3BM"
    static let secretKey = "szSRnbtDHe3fGcLkdgB3tmkqEprP9RhQ5naONjuGVvk"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let baseURLString = "https://unsplash.com"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let defaultApiBaseURLString = "https://api.unsplash.com"
    static let photoBaseURLString = "https://api.unsplash.com/photos"
    static let baseAuthTokenPath = "/oauth/token"
    
    static let bearerToken = "bearerToken"
}
