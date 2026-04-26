//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 22.03.2026.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as? ImagesListViewController else { return }
        
        let configuredImagesListVC = ImagesListModuleConfigurator.configure(
            viewController: imagesListViewController
        )
        
        let profileViewController = ProfileModuleConfigurator.configure()
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil
        )
        
        viewControllers = [configuredImagesListVC, profileViewController]
    }
}
