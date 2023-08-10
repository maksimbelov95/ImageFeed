import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateText: UILabel!
    static let reuseIdentifier = "ImagesListCell"
}
