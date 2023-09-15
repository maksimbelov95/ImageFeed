import Foundation

enum NetworkError: Error {
    case codeError
}

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope = "scope"
        case createdAt = "created_at"
    }
}

final class OAuth2Service {
    let DefaultBaseURL = URL(string: "https://unsplash.com")!
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    private func object(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) {
            (result: Result<Data, Error>) in
            let response = result.flatMap {
                data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let URLString: String = "/oauth/token" +
            "?client_id=\(AccessKey)" +
            "&client_secret=\(SecretKey)" +
            "&redirect_uri=\(RedirectURI)" +
            "&code=\(code)" +
            "&grant_type=authorization_code"
        
        var requestURL: URL {
            guard let requestURL = URL(string: URLString, relativeTo: DefaultBaseURL) else {
                preconditionFailure("Failed to build URL")
            }
            return requestURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let task = self.object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension URLSession {
    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        let successfulCompletion: (Result<Data, Error>) -> Void = { result in
            //Максим, я же тут оборачиваю в главный поток блок complition. Разве мне нужно вызывать его сверху
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if let error = error {
                    successfulCompletion(.failure(error))
                }
                if statusCode < 200 || statusCode >= 300 {
                    successfulCompletion(.failure(NetworkError.codeError))
                }
                successfulCompletion(.success(data))
            }
        } )
        task.resume()
        return task
    }
}
