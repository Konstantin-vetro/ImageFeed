//
//  ProfileViewController.swift
//  ImageFeed
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension ProfileViewController {
    private func setupUI() {
        let avatar = getAvaterImageView()
        let name = getNameLabel()
        let loginName = getLoginNameLabel()
        let description = getDescriptionLabel()
        let button = getLogoutButton()
        
    // MARK: - constraints
        NSLayoutConstraint.activate([
            avatar.heightAnchor.constraint(equalToConstant: 70),
            avatar.widthAnchor.constraint(equalToConstant: 70),
            avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            name.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 8),
            name.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            loginName.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            loginName.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            description.topAnchor.constraint(equalTo: loginName.bottomAnchor, constant: 8),
            description.leadingAnchor.constraint(equalTo: loginName.leadingAnchor),
            button.heightAnchor.constraint(equalToConstant: 24),
            button.widthAnchor.constraint(equalToConstant: 24),
            button.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    // MARK: - ImageAvatar
    private func getAvaterImageView() -> UIImageView {
        let profileImage = UIImage(named: "Photo Profile")
        let imageView = UIImageView(image: profileImage)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        return imageView
    }
    // MARK: - NameLabel
    private func getNameLabel() -> UILabel {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = label.font.withSize(23)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }
    // MARK: - LoginNameLabel
    private func getLoginNameLabel() -> UILabel {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .ypGray
        label.font = label.font.withSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }
    // MARK: - DescriptionLabel
    private func getDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.text = "Hello world!"
        label.textColor = .ypWhite
        label.font = label.font.withSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }
    // MARK: - LogoutButton
    private func getLogoutButton() -> UIButton {
        let image = UIImage(named: "logout icon")
        let button = UIButton.systemButton(
            with: image ?? UIImage(),
            target: self,
            action: #selector(Self.didTapLogoutButton)
            )
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }
    // MARK: - ActionButton
    @objc
    private func didTapLogoutButton(_ sender: UIButton) {
        print("tap")
    }
}

