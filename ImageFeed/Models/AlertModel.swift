//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 15.03.2026.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    
    let completion: (() -> Void)?
}
