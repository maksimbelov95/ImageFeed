
import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}
struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String
    let urls: UrlsResult
    let likedByUser: Bool
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.urls = try container.decode(UrlsResult.self, forKey: .urls)
        self.likedByUser = try container.decode(Bool.self, forKey: .likedByUser)
    }
}
struct UrlsResult: Codable {
    let full: String
    let thumb: String
}
