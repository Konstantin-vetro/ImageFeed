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
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
    
    func convertToPhoto() -> Photo {
        return Photo(
            id: self.id,
            size: CGSize(width: self.width, height: self.height),
            createdAt: ISO8601DateFormatter().date(from: self.createdAt ?? ""),
            welcomeDescription: self.description,
            thumbImageURL: self.urls.thumb,
            largeImageURL: self.urls.full,
            isLiked: self.likedByUser
        )
    }
}

struct UrlsResult: Decodable {
    let full: String
    let thumb: String
}

struct PhotoLike: Decodable {
    let photo: PhotoResult
}

extension Array {
    func withReplaced(itemAt index: Int, newValue: Element) -> Array {
        var newArray = self
        newArray[index] = newValue
        return newArray
    }
}
