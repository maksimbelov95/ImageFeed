import Foundation

final class OAuth2Service {
    
    private let urlSession: URLSession
    private let storage: OAuth2TokenStorage
    private var lastCode: String?
    private var currentTask: URLSessionTask?
    private let builder: URLRequestBuilder
    
    
    init(urlSession: URLSession = .shared, storage: OAuth2TokenStorage = .shared, builder: URLRequestBuilder = .shared) {
        self.urlSession = urlSession
        self.storage = storage
        self.builder = builder
    }
    
    var isAuthenticated: Bool{
        storage.token != nil
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard !(code == lastCode && currentTask != nil) else {return}
        lastCode = code
        guard let request = authTokenRequest(code: code) else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.InvalidRequest))
            return
        }
        let session = URLSession.shared
        currentTask = session.objectTask(for: request) {[weak self] (response: Result<OAuthTokenResponseBody, Error>) in
            self?.currentTask = nil
            switch response {
            case .success(let body):
                let authToken = body.accessToken
                self?.storage.token = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension OAuth2Service{
    private func authTokenRequest(code: String) -> URLRequest?{
        let baseAuthTokenPath = AuthConfiguration.standard.baseAuthTokenPath
        let accessKey = AuthConfiguration.standard.accessKey
        let secretKey = AuthConfiguration.standard.secretKey
        let redirectURI = AuthConfiguration.standard.redirectURI
        let defaultApiBaseURLString = AuthConfiguration.standard.defaultApiBaseURLString
        
        return builder.makeHTTPRequest(
            path: "\(baseAuthTokenPath)"
            + "?client_id=\(accessKey)"
            + "&&client_secret=\(secretKey)"
            + "&&redirect_uri=\(redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURLString: defaultApiBaseURLString
        )
    }
}

