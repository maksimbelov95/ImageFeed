
import Foundation

final class ImageListService{
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private (set) var photos: [PhotoResult] = []
    private var currentPage: Int = 0
    private var lastLoadedPage: Int = 1
    private var currentTask: URLSessionTask?
    func fetchPhotosNextPage(completion: @escaping([PhotoResult]) -> Void){
        guard let request = makeImageListServiceRequest() else {
            assertionFailure("Invalid request")
            return
        }
        if currentTask == nil{
            
            let session = URLSession.shared
            print(request)
            currentTask = session.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                if let error = error{
                    print(error)
                }
                guard let data = data else {return}
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let photos = try decoder.decode([PhotoResult].self, from: data)
                        completion(photos)
                        self.photos.append(contentsOf: photos)
                        print(photos)
                        print(self.photos.count)
                        self.lastLoadedPage += 1
                        NotificationCenter.default.post(name: ImageListService.DidChangeNotification,object: self,userInfo: ["photos": photos])
                    } catch {
                        print(NetworkError.decodingError(error))
                    }
            }
            currentTask?.resume()
        }else {return}
    }
    private func makeImageListServiceRequest() -> URLRequest? {
        var nextPage:Int = 0
            if lastLoadedPage == 1{
                nextPage = 1
            } else {
                nextPage = lastLoadedPage
        }
        print(lastLoadedPage)
        return makeHTTPRequest(
            path: "\(Constants.photoBaseURLString)"
            + "?client_id=\(Constants.accessKey)"
            + "&page=\(nextPage)"
            + "&per_page=10",
            httpMethod: "GET",
            baseURLString: Constants.photoBaseURLString)
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
