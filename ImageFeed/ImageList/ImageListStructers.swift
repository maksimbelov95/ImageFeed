
import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}
extension Photo{
    init(result photo: PhotoResult){
        self.init(
            id: photo.id,
            size: CGSize(width: photo.width, height: photo.height),
            createdAt: photo.createdAt,
            welcomeDescription: photo.description,
            thumbImageURL: photo.urls.thumb,
            largeImageURL: photo.urls.full,
            isLiked: photo.likedByUser
        )
    }
}
struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool
}
struct UrlsResult: Codable {
    let full: String
    let thumb: String
}
