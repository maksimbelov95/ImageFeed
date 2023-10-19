import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let authService = OAuth2Service()
    private let alertPresenter = AlertPresenter()
    private var wasChecked: Bool = false
    
    private let showLoginFlowSegueIdentifier = "ShowLoginFlow"
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = Images.authorizationLogo
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter.delegate = self
//        view.backgroundColor = Colors.logoViewBGColor
        
        layout()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkAuthStatus()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
    
    private func layout(){
        view.addSubview(backgroundImage)
        
        NSLayoutConstraint.activate([
            backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImage.heightAnchor.constraint(equalToConstant: 75),
            backgroundImage.widthAnchor.constraint(equalToConstant: 78)
        ])
    }
    private func checkAuthStatus(){
        guard !wasChecked else {return}
        wasChecked = true
        if authService.isAuthenticated {
            UIBlockingProgressHUD.show()
            fetchProfile {[weak self] in
                UIBlockingProgressHUD.dismiss()
                self?.switchToTabBarController()
            }
        } else {
            showAuthController()
        }
    }
    
    private func showAuthController(){
        let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthViewControllerID")
        guard let authViewController = viewController as? AuthViewController else {return}
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    private func switchToTabBarController(){
        guard let window = UIApplication.shared.windows.first else { fatalError("InvalidConfiguration")}
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate{
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        
        dismiss(animated: true){[weak self] in
            guard let self = self else {return}
            self.fetchOAuthToken(code)
        }
    }
    private func fetchOAuthToken(_ code: String){
        UIBlockingProgressHUD.show()
        
        authService.fetchOAuthToken(code) { [weak self] authResult in
        
            switch authResult{
            case .success(_):
                self?.fetchProfile(completion:{UIBlockingProgressHUD.dismiss()})
            case .failure(let error):
                self?.showLoginAlert(error: error)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    private func fetchProfile(completion: @escaping () -> Void){
        profileService.fetchProfile { [weak self] profileResult in
            switch profileResult{
            case .success(_):
                self?.switchToTabBarController()
            case .failure(let error):
                self?.showLoginAlert(error: error)
            }
            completion()
        }
    }
    private func showLoginAlert(error: Error){
        alertPresenter.showAlert(title:"Что-то пошло не так",
                                 message:"Не удалось войти в систему, \(error.localizedDescription)"){
                self.performSegue(withIdentifier: self.showLoginFlowSegueIdentifier, sender: nil)
            }
    }
    private func presentAuth(){
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AuthViewControllerID")
        guard let authViewController = viewController as? AuthViewController else {return}
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
}

