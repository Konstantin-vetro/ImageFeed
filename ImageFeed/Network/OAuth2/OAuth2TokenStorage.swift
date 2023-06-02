//
//  OAuth2TokenStorage.swift
//  ImageFeed
//

import Foundation

protocol OAuth2TokenStorageProtocol {
    var token: String? { get set }
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    private enum Keys: String {
        case bearerToken
    }

    private let userDefaults = UserDefaults.standard

    var token: String? {
      get {
        return userDefaults.string(forKey: Keys.bearerToken.rawValue)
      }
      set {
        userDefaults.set(newValue, forKey: Keys.bearerToken.rawValue)
      }
    }
}
