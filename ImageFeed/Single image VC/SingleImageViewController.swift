import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    var photo: Photo?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        loadAndDisplayImage()
    }

    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        if let imageToShare = imageView.image {
                    let sharingImage = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
                    present(sharingImage, animated: true)
                } else {
                    let alertController = UIAlertController(title: "Ошибка", message: "Произошла ошибка, повторите попозже", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alertController, animated: true, completion: nil)
                }
    }
    
    private func loadAndDisplayImage() {
        guard let imageURLString = photo?.largeImageURL, let imageURL = URL(string: imageURLString) else {
               return
           }
           
           UIBlockingProgressHUD.show()
           
           imageView.kf.indicatorType = .activity
           imageView.kf.setImage(with: imageURL, placeholder: nil, completionHandler: { [weak self] (result) in
               switch result {
               case .success(_):
                   UIBlockingProgressHUD.dismiss()
                   self?.rescaleAndCenterImageInScrollView(image: (self?.imageView.image)!)
               case .failure(_):
                   UIBlockingProgressHUD.dismiss()
                   let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так. Попробовать ещё раз?", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "Не надо", style: .cancel, handler: nil))
                   alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { (_) in
                       self?.loadAndDisplayImage()
                   }))
                   
                   self?.present(alert, animated: true, completion: nil)
               }
           })
       }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
