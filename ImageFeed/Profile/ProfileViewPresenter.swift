//
//  ProfileViewPresenter.swift
//  ImageFeed
//

import UIKit

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func updateProfileDetails()
    func updateAvatar()
    func logout()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
        
    init(
        profileService: ProfileServiceProtocol = ProfileService.shared,
        profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
    func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        view?.setupProfileDetails(
            name: profile.name ?? "",
            login: profile.loginName,
            bio: profile.bio ?? ""
        )
        updateAvatar()
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        view?.setupAvatar(url: url)
    }
    
    func logout() {
        OAuth2TokenStorage.shared.clean()
        WebViewViewController.clean()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = windowScene.windows.first
            
            window?.rootViewController = SplashViewController()
            window?.makeKeyAndVisible()
        }
    }
}
