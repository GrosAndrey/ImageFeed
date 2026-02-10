//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 06.02.2026.
//

import UIKit

final class ProfileViewController: UIViewController {
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var loginLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    
    @IBOutlet weak private var logoutButton: UIButton!
    
    @IBAction private func didTapLogoutButton() {
    }
    
    
}
