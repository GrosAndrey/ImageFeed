//
//  ProfileModuleConfigurator.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 23.04.2026.
//

import UIKit

final class ProfileModuleConfigurator {
    
    static func configure() -> ProfileViewController {
        let view = ProfileViewController()
        let presenter = ProfilePresenter()
        
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
}
