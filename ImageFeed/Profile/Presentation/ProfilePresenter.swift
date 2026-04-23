//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 22.04.2026.
//

import UIKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func updateProfileDetails()
    func updateAvatar()
    func observerProfileImageService()
    func didTapLogout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
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
        let model = AlertModel(
            title: "Пока, пока",
            message: "Уверены, что хотите выйти?",
            actions: [
                AlertActionModel(
                    title: "Да",
                    style: .default,
                    completion: { [weak self] in
                        guard let self else { return }
                        profileLogoutService.logout()
                        view?.switchToSplashViewController()
                    }),
                AlertActionModel(
                    title: "Нет",
                    style: .default,
                    completion: nil)
            ]
        )
        view?.showAlert(model)
    }
}
