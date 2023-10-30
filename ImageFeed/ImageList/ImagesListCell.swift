import Foundation
import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImageListCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    func setIsLike(_ isLike: Bool) {
            let isLikeImage = isLike ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
            likeButton.setImage(isLikeImage, for: .normal)
        }
}
