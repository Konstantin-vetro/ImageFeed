//
//  Photo.swift
//  ImageFeed
//

import Foundation


struct Photo: Codable {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    init(photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = ISO8601DateFormatter().date(from: photoResult.createdAt ?? "")
        self.isLiked = photoResult.likedByUser
        self.welcomeDescription = photoResult.description
        self.largeImageURL = photoResult.urls?.full ?? ""
        self.thumbImageURL = photoResult.urls?.thumb ?? ""
    }
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult?
}

struct UrlsResult: Decodable {
    let full: String?
    let thumb: String?
}
