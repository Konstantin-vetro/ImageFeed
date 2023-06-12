//
//  ProfileViewController.swift
//  ImageFeed
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    
    let avatar: UIImageView = {
        let profileImage = UIImage(named: "Photo Profile")
        let imageView = UIImageView(image: profileImage)
        imageView.tintColor = .gray
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = label.font.withSize(23)
        return label
    }()
    
    let loginNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "@ekaterina_nov"
        label.textColor = .ypGray
        label.font = label.font.withSize(13)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Hello world!"
        label.textColor = .ypWhite
        label.font = label.font.withSize(13)
        return label
    }()
    
    let logoutButton: UIButton = {
        let image = UIImage(named: "logout icon")
        let button = UIButton.systemButton(
            with: image ?? UIImage(),
            target: self,
            action: #selector(didTapLogoutButton)
        )
        button.tintColor = .ypRed
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        setupUI()
        updateProfileDetails(profile: profileService.profile)
    }
    
    @objc private func didTapLogoutButton(_ sender: UIButton) {
        print("tap")
    }
}

// MARK: - SetupUI
private extension ProfileViewController {
    private func setupUI() {
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

// MARK: - Setup Profile
extension ProfileViewController {
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
}

// MARK: - Status Bar
extension ProfileViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
