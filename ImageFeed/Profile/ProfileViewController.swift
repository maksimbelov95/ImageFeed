import UIKit
import WebKit
import SwiftKeychainWrapper
import Foundation
import Kingfisher

final class ProfileViewController: UIViewController {
    

    @IBAction private func didTapLogoutButton() {}
    private let profileImageService = ProfileImageService.shared
    private let labelName = UILabel()
    private let labelMail = UILabel()
    private let labelBio = UILabel()
    private var imageView = UIImageView()
    private let splashViewController = SplashViewController()
    private var profileImageServiceObserver: NSObjectProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard OAuth2TokenStorage().token != nil else {return}
        do {
            ProfileService.shared.fetchProfile() { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let profile):
                    self.labelName.text = profile.name
                    self.labelMail.text = profile.loginName
                    self.labelBio.text = profile.bio
                case .failure(let error):
                    print("Не удалось получить сохраненный профиль: \(error)")
                }
            }
        }
        
        if let url = profileImageService.avatarURL{
            updateAvatar(url: url)
        }
        
        view.addSubview(imageView)
        imageView.tintColor = .gray
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        view.addSubview(labelName)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.textColor = .white
        labelName.font = UIFont.boldSystemFont(ofSize: 23)
        labelName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true

        
        view.addSubview(labelMail)
        labelMail.translatesAutoresizingMaskIntoConstraints = false
        labelMail.textColor = UIColor(named: "YP Gray (iOS)")
        labelMail.font = UIFont.systemFont(ofSize: 13)
        labelMail.leadingAnchor.constraint(equalTo: labelName.leadingAnchor).isActive = true
        labelMail.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8).isActive = true

        
        view.addSubview(labelBio)
        labelBio.translatesAutoresizingMaskIntoConstraints = false
        labelBio.textColor = .white
        labelBio.font = UIFont.systemFont(ofSize: 13)
        labelBio.leadingAnchor.constraint(equalTo: labelName.leadingAnchor).isActive = true
        labelBio.topAnchor.constraint(equalTo: labelMail.bottomAnchor, constant: 8).isActive = true
   
        
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        button.tintColor = UIColor(named: "YP Red (iOS)")
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    @objc
    private func didTapButton()  {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "bye_bye"
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
            KeychainWrapper.standard.removeAllKeys()
            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
            WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                               WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                           }
                       }
            window.rootViewController = self.splashViewController
        }
        yesAction.accessibilityIdentifier = "logout_yes"
        
        let noAction = UIAlertAction(title: "Нет", style: .cancel)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func updateAvatar(url: URL){
        imageView.kf.setImage(with: url)
        print(url)
    }
}
