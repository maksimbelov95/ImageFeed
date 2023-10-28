import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    override func prepareForReuse() {
           super.prepareForReuse()
           
           cellImage.kf.cancelDownloadTask()
       }
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImageListCellDelegate?
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    
    
}

