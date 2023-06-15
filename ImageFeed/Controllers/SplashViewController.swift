//
//  SplashViewController.swift
//  ImageFeed
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private lazy var logoLabel: UIImageView = {
        let image = UIImage(named: "Logo")
        let logoImage = UIImageView(image: image)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        return logoImage
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkToken()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
// MARK: - SetupUI
    private func setupUI() {
        view.backgroundColor = .ypBlack
        view.addSubview(logoLabel)
        
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            logoLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0)
        ])
    }
    
// MARK: - StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func checkToken() {
        if let token = oauth2TokenStorage.token {
            UIBlockingProgressHUD.show()
            self.fetchProfile(token: token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
            
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
// MARK: - Switch to TabBarController
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showError()
                break
            }
        }
    }
    
// MARK: - FetchProfile
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                guard let userName = self.profileService.profile?.username else { return }
                self.profileImageService.fetchProfileImageURL(userName) { _ in }
                self.switchToTabBarController()
            case .failure:
                self.showError()
                break
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { [weak self] _ in
            guard let self else { return }
            self.checkToken()
        }))
        present(alert, animated: true)
    }
}

