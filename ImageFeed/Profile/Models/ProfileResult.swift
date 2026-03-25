//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 11.03.2026.
//

import Foundation

struct ProfileResult: Codable {
    let userName: String
    let firstName: String
    let lastName: String?
    let bio: String?
    var name: String {
        return "\(firstName) \(lastName ?? "")"
    }
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case userName = "username"
        case bio = "bio"
    }
}
