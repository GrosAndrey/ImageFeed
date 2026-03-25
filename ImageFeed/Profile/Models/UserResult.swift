//
//  UserResult.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 13.03.2026.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}
