//
//  ProfileViewController.swift
//  ImageFeed
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func setupProfileDetails(name: String, login: String, bio: String)
    func setupAvatar(url: URL)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol? = {
       return ProfileViewPresenter()
    }()
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private let avatarPlaceHolder = UIImage(named: "placeholder.png")

// MARK: - UI-elements
    private lazy var avatar: UIImageView = {
        let profileImage = avatarPlaceHolder
        let imageView = UIImageView(image: profileImage)
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.tintColor = .gray
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = label.font.withSize(23)
        return label
    }()
    
    private lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "@ekaterina_nov"
        label.textColor = .ypGray
        label.font = label.font.withSize(13)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Hello world!"
        label.textColor = .ypWhite
        label.font = label.font.withSize(13)
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let image = UIImage(named: "logout icon")
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        button.tintColor = .ypRed
        return button
    }()
// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        presenter?.view = self
        presenter?.updateProfileDetails()

        setupUI()
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.presenter?.updateAvatar()
            }
    }
    
    @objc
    private func didTapLogoutButton() {
        let alert = UIAlertController(title: "Пока Пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Да", style: .default, handler: { _ in
            self.presenter?.logout()
        })
        
        let cancelAction = UIAlertAction(title: "Нет", style: .default, handler: { _ in alert.dismiss(animated: true)})

        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
// MARK: - Setup Avatar
    func setupAvatar(url: URL) {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        avatar.kf.indicatorType = IndicatorType.activity
        avatar.kf.setImage(with: url, placeholder: avatarPlaceHolder) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let image):
                self.avatar.image = image.image
            case .failure:
                self.avatar.image = self.avatarPlaceHolder
            }
        }
    }
    
// MARK: - Setup Profile
    func setupProfileDetails(name: String, login: String, bio: String) {
        nameLabel.text = name
        loginNameLabel.text = login
        descriptionLabel.text = bio
    }
}

// MARK: - Layouts
private extension ProfileViewController {
    func setupUI() {
        [avatar, nameLabel, loginNameLabel, descriptionLabel, logoutButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            avatar.heightAnchor.constraint(equalToConstant: 70),
            avatar.widthAnchor.constraint(equalToConstant: 70),
            avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            nameLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            logoutButton.heightAnchor.constraint(equalToConstant: 24),
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - Status Bar
extension ProfileViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
