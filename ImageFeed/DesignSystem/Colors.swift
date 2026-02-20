//
//  Colors.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 20.02.2026.
//

import UIKit

enum DSColor {
    
    static var ypBlack: UIColor {
        guard let color = UIColor(named: "YP_black") else {
            assertionFailure("Color YP_black not found")
            return .black
        }
        return color
    }
    static var ypGray: UIColor {
        guard let color = UIColor(named: "YP_gray") else {
            assertionFailure("Color YP_gray not found")
            return .gray
        }
        return color
    }
}
