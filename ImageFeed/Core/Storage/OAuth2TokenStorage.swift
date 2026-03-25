//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 03.03.2026.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "OAuthToken"
    
    private init() {}
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            guard let token = newValue else { return }
            KeychainWrapper.standard.set(token, forKey: tokenKey)
        }
    }
}
