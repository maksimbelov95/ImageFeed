import UIKit

final class ProfileViewController: UIViewController {
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var logoutButton: UIButton!
    @IBAction private func didTapLogoutButton() {}
    private var labelName: UILabel?
    private var labelMail: UILabel?
    private var labelHello: UILabel?
    private var profileImage = UIImage(named: "avatar")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let imageView = UIImageView(image: profileImage)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let labelName = UILabel()
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.text = "Екатерина Новикова"
        labelName.textColor = .white
        labelName.font = UIFont.systemFont(ofSize: 23)
        view.addSubview(labelName)
        labelName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        self.labelName = labelName
        
        let labelMail = UILabel()
        labelMail.translatesAutoresizingMaskIntoConstraints = false
        labelMail.text = "@ekaterina_nov"
        labelMail.textColor = UIColor(named: "YP Gray (iOS)")
        labelMail.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(labelMail)
        labelMail.leadingAnchor.constraint(equalTo: labelName.leadingAnchor).isActive = true
        labelMail.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8).isActive = true
        self.labelMail = labelMail
        
        let labelHello = UILabel()
        labelHello.translatesAutoresizingMaskIntoConstraints = false
        labelHello.text = "Hello, world!"
        labelHello.textColor = .white
        labelHello.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(labelHello)
        labelHello.leadingAnchor.constraint(equalTo: labelName.leadingAnchor).isActive = true
        labelHello.topAnchor.constraint(equalTo: labelMail.bottomAnchor, constant: 8).isActive = true
        self.labelHello = labelHello
        
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    @objc
    private func didTapButton() {
        profileImage = UIImage(named: "profile_out_image")
        let imageView = UIImageView(image: profileImage)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            }
        }
    }
}
