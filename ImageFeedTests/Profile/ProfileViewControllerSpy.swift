//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Андрей Грошев on 23.04.2026.
//

import Foundation
import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var profileImageURL: URL?
    var showAlert = false
    var nameLabel = ""
    var loginNameLabel = ""
    var descriptionLabel = ""
    
    
    var presenter: ProfilePresenterProtocol?
    
    func setupProfileDetails(name: String, login: String, bio: String) {
        nameLabel = name
        loginNameLabel = login
        descriptionLabel = bio
    }
    
    func setupAvatar(url: URL) {
        
    }
    
    func showAlert(_ alertModel: AlertModel) {
        showAlert = true
    }
    
    func switchToSplashViewController() {
        
    }
    
}
