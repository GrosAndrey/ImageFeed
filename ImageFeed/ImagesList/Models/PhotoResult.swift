//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 31.03.2026.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let width: CGFloat
    let height: CGFloat
    let createdAt: Date?
    let welcomeDescription: String?
    let isLiked: Bool
    let urlsResult: UrlsResult
    
    private enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case isLiked = "liked_by_user"
        case urlsResult = "urls"
    }
}

struct UrlsResult: Codable {
    let thumbImageURL: String
    let largeImageURL: String
    
    private enum CodingKeys: String, CodingKey {
        case thumbImageURL = "thumb"
        case largeImageURL = "full"
    }
}
