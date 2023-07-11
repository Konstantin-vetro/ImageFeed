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
    static let defaultBaseURL: URL = URL(string: "https://api.unsplash.com")!
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: String
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: String, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: APIKeys.AccessKey,
            secretKey: APIKeys.SecretKey,
            redirectURI: APIKeys.RedirectURI,
            accessScope: APIKeys.AccessScope,
            defaultBaseURL: APIKeys.defaultBaseURL.absoluteString,
            authURLString: APIKeys.UnsplashAuthorizeURLString
        )
    }
}

