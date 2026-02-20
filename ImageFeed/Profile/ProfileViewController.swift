//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 06.02.2026.
//

import UIKit

final class ProfileViewController: UIViewController {
    private enum TextLabel {
        case nameLabel
        case loginNameLabel
        case descriptionLabel
        
        var text: String {
            switch self {
            case .nameLabel:
                return "Екатерина Новикова"
            case .loginNameLabel:
                return "@ekaterina_nov"
            case .descriptionLabel:
                return "Hello, World!"
            }
        }
    }
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let actionButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
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
        let imageResource: ImageResource = .avatar
        let profileImage: UIImage = UIImage(resource: imageResource)
        avatarImageView.image = profileImage
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureNameLabel() {
        let fontSemibold = UIFont.systemFont(ofSize: 23, weight: .semibold)
        
        nameLabel.text = TextLabel.nameLabel.text
        nameLabel.font = fontSemibold
        nameLabel.textColor = UIColor.white
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLoginLabel() {
        loginNameLabel.text = TextLabel.loginNameLabel.text
        loginNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.textColor = DSColor.ypGray
        
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.text = TextLabel.descriptionLabel.text
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = UIColor.white
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureButton() {
        let imageResource: ImageResource = .logoutButton
        let logoutImage: UIImage = UIImage(resource: imageResource)
        actionButton.setImage(logoutImage, for: .normal)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
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
    
    @objc
    private func didTapLogoutButton() {
        // TODO:
    }
}
