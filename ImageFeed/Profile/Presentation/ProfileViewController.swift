//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 06.02.2026.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    
    func setupProfileDetails(name: String, login: String, bio: String)
    func setupAvatar(url: URL)
    func switchToSplashViewController()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    private let alertPresenter = ResultAlertPresenter()
    
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let actionButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        self.presenter = ProfileViewPresenter(viewController: self)
        presenter?.viewDidLoad()
    }
    
    private func configure() {
        configureView()
        configureImageView()
        configureNameLabel()
        configureLoginLabel()
        configureDescriptionLabel()
        configureButton()
        
        setupHierarchy()
        setupConstraints()
    }
    
    private func configureView() {
        view.backgroundColor = DSColor.ypBlack
    }
    
    private func configureImageView() {
        avatarImageView.image = UIImage(resource: .avatar)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureNameLabel() {
        let fontSemibold = UIFont.systemFont(ofSize: 23, weight: .semibold)
        
        nameLabel.text = ""
        nameLabel.font = fontSemibold
        nameLabel.textColor = UIColor.white
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLoginLabel() {
        loginNameLabel.text = ""
        loginNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.textColor = DSColor.ypGray
        
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.text = ""
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = UIColor.white
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureButton() {
        let logoutImage = UIImage(resource: .logoutButton)
        actionButton.setImage(logoutImage, for: .normal)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        actionButton.accessibilityIdentifier = "LogoutButton"
    }
    
    private func setupHierarchy() {
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(loginNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(actionButton)
    }
    
    private func setupConstraints() {
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        
        descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        
        actionButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
    }
    
    func setupProfileDetails(name: String, login: String, bio: String) {
        nameLabel.text = name
        loginNameLabel.text = login
        descriptionLabel.text = bio
    }
    
    func setupAvatar(url: URL) {
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(
                UIImage.SymbolConfiguration(
                    pointSize: 70,
                    weight: .regular,
                    scale: .large
                )
            )
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]
        )
    }
    
    func switchToSplashViewController() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        window.rootViewController = SplashViewController()
    }
    
    @objc
    private func didTapLogoutButton() {
        let model = AlertModel(
            title: "Пока, пока",
            message: "Уверены, что хотите выйти?",
            actions: [
                AlertActionModel(
                    title: "Да",
                    style: .default,
                    completion: { [weak self] in
                        guard let self else { return }
                        presenter?.didTapLogout()
                    }),
                AlertActionModel(
                    title: "Нет",
                    style: .default,
                    completion: nil)
            ]
        )
        alertPresenter.show(in: self, model: model)
    }
}
