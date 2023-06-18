//
//  Profile.swift
//  ImageFeed
//

import Foundation

struct Profile: Codable {
    let username: String?
    let name: String?
    let loginName: String
    let bio: String?
    init(ProfileResult: ProfileResult) {
        self.username = ProfileResult.username
        self.name = (ProfileResult.firstName ?? "") + " " + (ProfileResult.lastName ?? "")
        self.loginName = "@" + (ProfileResult.username ?? "")
        self.bio = ProfileResult.bio
    }
}
