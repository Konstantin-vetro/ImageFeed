//
//  ProfileTests.swift
//  ImageFeedTests
//

@testable import ImageFeed
import XCTest


final class ProfileTests: XCTestCase {
    private struct ProfileServiceStub: ProfileServiceProtocol {
        var profile: Profile? = Profile(ProfileResult: ProfileResult(username: "test", firstName: "test", lastName: "test"))
        func fetchProfile(_ token: String, completion: @escaping (Result<ImageFeed.Profile, Error>) -> Void) {}
    }
    
    private struct ProfileImageServiceStub: ProfileImageServiceProtocol {
        var avatarURL: String? = "https://api.unsplash.com"
        func fetchProfileImageURL(_ username: String, completion: @escaping (Result<String, Error>) -> Void) {}
    }
    
    func testProfileUpdateProfileDetailsCalls() {
        // given
        let viewController = ProfileViewController()
        let spyPresenter = ProfileViewPresentSpy()
        viewController.presenter = spyPresenter
        spyPresenter.view = viewController

        // when
        _ = viewController.view

        // then
        XCTAssertTrue(spyPresenter.updateProfileDetailsCalled)
    }
    
    func testViewControllerSetProfileDetailsCalls() {
        // given
        let viewController = ProfileViewControllerSpy()
        let profileServiceStub = ProfileServiceStub()
        let profileImageServiceStub = ProfileImageServiceStub()
        let presenter = ProfileViewPresenter(
            profileService: profileServiceStub,
            profileImageService: profileImageServiceStub
        )
        viewController.presenter = presenter
        presenter.view = viewController

        // when
        presenter.updateProfileDetails()

        // then
        XCTAssertTrue(viewController.setupProfileDetailsCalled)
        XCTAssertTrue(viewController.setupAvatarCalled)
    }
}

final class ProfileViewPresentSpy: ProfileViewPresenterProtocol {
        
    var view: ImageFeed.ProfileViewControllerProtocol?
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    
    func updateProfileDetails() {
        updateProfileDetailsCalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func logout() {
       
    }
}

final class ProfileViewControllerSpy : ProfileViewControllerProtocol {
    
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    var setupProfileDetailsCalled = false
    var setupAvatarCalled = false
    
    func setupProfileDetails(name: String, login: String, bio: String) {
        setupProfileDetailsCalled = true
    }
    
    func setupAvatar(url: URL) {
        setupAvatarCalled = true
    }
}
