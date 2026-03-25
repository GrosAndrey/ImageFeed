//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 04.03.2026.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
