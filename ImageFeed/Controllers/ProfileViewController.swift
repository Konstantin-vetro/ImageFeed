//
//  ProfileViewController.swift
//  ImageFeed
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension ProfileViewController {
    private func setupUI() {
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
                action: #selector(Self.didTapLogoutButton)
                )
            button.tintColor = .ypRed
            return button
        }()

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
    
    @objc private func didTapLogoutButton(_ sender: UIButton) {
        print("tap")
    }
}

// MARK: - Status Bar
extension ProfileViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
