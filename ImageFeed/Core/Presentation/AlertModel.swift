//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 15.03.2026.
//

import UIKit

struct AlertActionModel {
    let title: String
    let style: UIAlertAction.Style
    let completion: (() -> Void)?
}

struct AlertModel {
    let title: String
    let message: String
    
    let actions: [AlertActionModel]
}
