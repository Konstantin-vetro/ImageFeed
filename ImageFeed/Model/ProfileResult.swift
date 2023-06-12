//
//  ProfileResult.swift
//  ImageFeed
//

import Foundation

struct ProfileResult: Codable {
    let userName: String?
    let firstName: String?
    let lastName: String?
    var bio: String?
}

struct Profile: Codable {
    let userName: String?
    let name: String?
    let loginName: String
    let bio: String?
    init(ProfileResult: ProfileResult) {
        self.userName = ProfileResult.userName
        self.name = (ProfileResult.firstName ?? "") + " " + (ProfileResult.lastName ?? "")
        self.loginName = "@" + (ProfileResult.userName ?? "")
        self.bio = ProfileResult.bio
    }
}
