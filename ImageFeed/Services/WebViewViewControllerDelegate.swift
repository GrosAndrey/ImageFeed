//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 27.02.2026.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
