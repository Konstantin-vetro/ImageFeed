//
//  Contacts.swift
//  ImageFeed
//

import Foundation

enum APIKeys {
    static let AccessKey = "S81qtH00tSlXekh96Vh21C38r2mT9ayNwRkL0wwF0mk"
    static let SecretKey = "V8REwryETlj3WumDe0ItXWoRqR8qLEdDvFjmR00xjVM"
    static let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let AccessScope = "public+read_user+write_likes"
    static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let bearerToken = "https://unsplash.com/oauth/token"
    static let DefaultBaseURL: URL = URL(string: "https://api.unsplash.com")!
}


