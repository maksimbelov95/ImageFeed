
import Foundation

final class ImageListService{
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private (set) var photos: [Photo] = []
    private var currentPage: Int = 0
    private var lastLoadedPage: Int = 1
    private var currentTask: URLSessionTask?
    private lazy var dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                formatter.timeStyle = .none
                return formatter
            }()
    func fetchPhotosNextPage(completion: @escaping([Photo]) -> Void){
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
                    for item in photos {
                        let photo = Photo(
                            id: item.id,
                            size: CGSize(width: item.width, height: item.height),
                            createdAt: item.createdAt,
                            welcomeDescription: item.description ?? "",
                            thumbImageURL: item.urls.thumb,
                            largeImageURL: item.urls.full,
                            isLiked: item.likedByUser)
                        self.photos.append(photo)
                    }
                    self.lastLoadedPage += 1
                    NotificationCenter.default.post(name: ImageListService.DidChangeNotification,object: self,userInfo: ["photos": photos])
                } catch {
                    print(NetworkError.decodingError(error))
                }
            }
            currentTask?.resume()
        }else {return}
    }
     func makeImageListServiceRequest() -> URLRequest? {
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
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void){
        assert(Thread.isMainThread)
//
//        guard let request = makeImageListServiceRequest() else {
//            assertionFailure("Invalid request")
//            return
//        }
//        // Поиск индекса элемента
//        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
//            // Текущий элемент
//           let photo = self.photos[index]
//           // Копия элемента с инвертированным значением isLiked.
//           let newPhoto = Photo(
//                    id: photos.id,
//                    size: photos.size,
//                    createdAt: photos.createdAt,
//                    welcomeDescription: photos.welcomeDescription,
//                    thumbImageURL: photos.urls.thumb,
//                    largeImageURL: photos.urls.full,
//                    isLiked: !photo.isLiked
//                )
//            // Заменяем элемент в массиве.
//            self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
//        }
//
//    }
//    private func makeChangeLikeRequest() -> URLRequest? {
//        let httpMethod = isLike == true ? "POST" : "DELETE"
//        return makeHTTPRequest(
//            path: "/photos"
//            + "?client_id=\(Constants.accessKey)"
//            + "/\(photoId)"
//            + "/like",
//            httpMethod: httpMethod,
//            baseURLString: Constants.photoBaseURLString)
    }
    
}
