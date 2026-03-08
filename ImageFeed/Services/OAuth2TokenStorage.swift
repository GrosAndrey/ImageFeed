//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 03.03.2026.
//

import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let storage: UserDefaults = .standard
    private let tokenKey = "OAuthToken"
    
    private init() {}
    
    var token: String? {
        get {
            storage.string(forKey: tokenKey)
        }
        set {
            storage.set(newValue, forKey: tokenKey)
        }
    }
}
