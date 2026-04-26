//
//  ImageListModuleConfigurator.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 23.04.2026.
//

import UIKit

final class ImagesListModuleConfigurator {
    
    static func configure(viewController: ImagesListViewController) -> ImagesListViewController {
        let presenter = ImagesListPresenter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        return viewController
    }
}
