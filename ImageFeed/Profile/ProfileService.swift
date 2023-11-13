
import Foundation
import UIKit

final class ProfileService {
    static let shared = ProfileService()
    
    private let builder: URLRequestBuilder
    
    private(set) var profile: Profile?
    private var currentTask: URLSessionTask?
    
    
    private init(builder: URLRequestBuilder = .shared) {
        self.builder = builder
    }
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void){
        currentTask?.cancel()
        
        guard let request = makeFetchProfileRequest() else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.InvalidRequest))
            return
        }
        let session = URLSession.shared
        currentTask = session.objectTask(for: request) {[weak self] (response: Result<ProfileResult, Error>) in
            self?.currentTask = nil
            switch response{
            case .success(let profileResult):
                let profile = Profile(result: profileResult)
                self?.profile = profile
                completion(.success(profile))
                ProfileImageService.shared.fetchProfileImageURL(userName: profile.username) { _ in }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    private func makeFetchProfileRequest() -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURLString:  AuthConfiguration.standard.defaultApiBaseURLString)
    }

}


