//
//  Photo.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 31.03.2026.
//

import Foundation

public struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
