//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Андрей Грошев on 23.04.2026.
//

import Foundation
import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled = false
    
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateProfileDetails() { }
    
    func updateAvatar() { }
    
    func observerProfileImageService() { }
    
    func didTapLogout() { }
}
