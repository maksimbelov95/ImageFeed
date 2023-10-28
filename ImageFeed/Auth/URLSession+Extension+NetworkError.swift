
import Foundation

import Foundation

enum NetworkError: Error {
    case decodingError(Error)
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case InvalidRequest
}

final class URLRequestBuilder{
    static let shared = URLRequestBuilder()
    
    private let storage: OAuth2TokenStorage
    
    private init(storage: OAuth2TokenStorage = .shared) {
        self.storage = storage
    }
    
    func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURLString: String
    ) -> URLRequest? {
        guard
        let url = URL(string: baseURLString),
        let baseUrl = URL(string: path, relativeTo: url)
        else {return nil}
        var request = URLRequest(url: baseUrl)
        request.httpMethod = httpMethod
        
        if let token = OAuth2TokenStorage.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}

extension URLSession{
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping(Result<T, Error>) -> Void) -> URLSessionTask{
            let fulfillCompletionOnMainThread: (Result<T, Error>) -> Void =
            { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: {data, response, error in
                print(request)
                if let data = data, let response = response, let statusCode = (response as?
                                                                               HTTPURLResponse)?.statusCode {
                    if 200 ..< 300 ~= statusCode {
                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let result = try decoder.decode(T.self, from: data)
                            fulfillCompletionOnMainThread(.success(result))
                        }catch{
                            fulfillCompletionOnMainThread(.failure(NetworkError.decodingError(error)))
                        }
                    } else {fulfillCompletionOnMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                } else if let error = error {fulfillCompletionOnMainThread(.failure(NetworkError.urlRequestError(error)))
                } else {fulfillCompletionOnMainThread(.failure(NetworkError.urlSessionError))
                }
            })
            task.resume()
            return task
        }
}

