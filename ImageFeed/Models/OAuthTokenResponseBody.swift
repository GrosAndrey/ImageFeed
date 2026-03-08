//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 03.03.2026.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
