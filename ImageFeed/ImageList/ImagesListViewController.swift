import UIKit
import Kingfisher
import ProgressHUD

final class ImagesListViewController: UIViewController, ImageListCellDelegate {

    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"

    @IBOutlet private var tableView: UITableView!
    
    private let imageListServise = ImageListService()
    private var imageListServiceObserver: NSObjectProtocol?

    private var photos: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imageListServise.fetchPhotosNextPage{[weak self] result in
            DispatchQueue.main.async {
                guard let self else {return}
                self.photos.append(contentsOf: result)
                self.tableView.reloadData()
            }
        }
        imageListServiceObserver = NotificationCenter.default.addObserver(
                   forName: ImageListService.DidChangeNotification,
                   object: nil,
                   queue: .main
                   ) { [weak self] _ in
                       guard let self = self else { return }
                       self.updateTableViewAnimated()
                   }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let photo = photos[indexPath.row]
            viewController.photo = photo
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as! ImagesListCell
        cell.delegate = self
        cell.dateLabel.text = dateFormatter.string(from: Date())
        let imageURL = URL(string: photos[indexPath.row].thumbImageURL)
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "placeholder_image")) { _ in
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        return cell
    }
        func updateTableViewAnimated() {
            let oldCount = photos.count
            let newCount = imageListServise.photos.count
            photos = imageListServise.photos
            if oldCount != newCount {
                tableView.performBatchUpdates {
                    let indexPaths = (oldCount..<newCount).map { i in
                        IndexPath(row: i, section: 0)
                    }
                    tableView.insertRows(at: indexPaths, with: .automatic)
                } completion: { _ in }
            }
        }
    
}
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photos[indexPath.row].size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photos[indexPath.row].size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row == photos.count - 1 {
                print("условие выполнено, вызываю fetchPhotosNextPage")
                imageListServise.fetchPhotosNextPage{[weak self] result in
                    DispatchQueue.main.async {
                        guard let self else {return}
                        self.photos.append(contentsOf: result)
                        self.updateTableViewAnimated()
                    }
                }
            }
        }
}
extension ImagesListViewController{
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let photo = photos[indexPath.row]
         photos[indexPath.row] = photo
        imageListServise.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
             guard let self = self else { return }
             
             switch result {
             case .success:
                 DispatchQueue.main.async {
                     self.tableView.reloadRows(at: [indexPath], with: .none)
                     UIBlockingProgressHUD.dismiss()
                 }
                 
             case .failure(let error):
                 DispatchQueue.main.async {
                     UIBlockingProgressHUD.dismiss()
                     print(error)
                 }
             }
         }
     }
}
