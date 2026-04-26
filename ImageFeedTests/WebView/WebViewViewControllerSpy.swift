//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Андрей Грошев on 21.04.2026.
//

import Foundation
import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) { }
    
    func setProgressHidden(_ isHidden: Bool) { }
}

final class AuthHelperStub: AuthHelperProtocol {
    func createAuthRequest() -> URLRequest? {
        URLRequest(url: URL(string: "https://example.com")!)
    }
    
    func getCode(from url: URL) -> String? {
        nil
    }
}
