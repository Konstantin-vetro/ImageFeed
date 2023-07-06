//
//  OAuth2TokenStorage.swift
//  ImageFeed
//

import Foundation
import SwiftKeychainWrapper

protocol OAuth2TokenStorageProtocol {
    var token: String? { get set }
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    
    static let shared = OAuth2TokenStorage()
    
    init() {}
    private enum Keys: String {
        case bearerToken
    }

    private let keychainWrapper = KeychainWrapper.standard

    var token: String? {
      get {
        keychainWrapper.string(forKey: Keys.bearerToken.rawValue)
      }
      set {
          guard let newValue else { return }
          keychainWrapper.set(newValue, forKey: Keys.bearerToken.rawValue)
      }
    }
    
    func clean() {
        keychainWrapper.removeAllKeys()
    }
}
