//
//  Profile.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 24.03.2026.
//

import Foundation

public struct Profile {
    let userName: String
    let name: String
    let bio: String
    var loginName: String {
        return "@\(userName)"
    }
}
