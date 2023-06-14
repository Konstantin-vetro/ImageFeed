//
//  UserResult.swift
//  ImageFeed
//

import Foundation

struct UserResult: Codable {
    let profileImage: [String: String]//ProfileImage
}

struct ProfileImage: Codable {
    let small: String
}
