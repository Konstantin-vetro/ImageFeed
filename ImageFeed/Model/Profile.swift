//
//  Profile.swift
//  ImageFeed
//

import Foundation

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
