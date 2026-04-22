//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 22.04.2026.
//

import UIKit

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func updateProfileDetails()
    func updateAvatar()
    func observerProfileImageService()
    func didTapLogout()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(viewController: ProfileViewControllerProtocol) {
        self.view = viewController
    }
    
    func viewDidLoad() {
        updateProfileDetails()
        observerProfileImageService()
        updateAvatar()
    }
    
    func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        
        let login = profile.loginName.isEmpty
            ? "@неизвестный_пользователь"
            : profile.loginName
        
        let name = profile.name.isEmpty
            ? "Имя не указано"
            : profile.name
        
        let bio = profile.bio.isEmpty
            ? "Профиль не заполнен"
            : profile.bio
        
        view?.setupProfileDetails(name: name, login: login, bio: bio)
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        view?.setupAvatar(url: url)
    }
    
    func observerProfileImageService() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatar()
        }
    }
    
    func didTapLogout() {
        profileLogoutService.logout()
        view?.switchToSplashViewController()
    }
}
