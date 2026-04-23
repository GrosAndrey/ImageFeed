//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Андрей Грошев on 23.04.2026.
//

import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {
    
    @MainActor
    func testViewControllerCallsViewDidLoad() {
        // Given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    @MainActor
    func testPresenterAlertShow() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.didTapLogout()
        
        // Then
        XCTAssertTrue(viewController.showAlert)
    }
    
    func testSetProfileDetailsPassesCorrectData() {
        // Given
        let viewController = ProfileViewControllerSpy()
        
        let name = "Andrey Groshev"
        let login = "@grosandrey"
        let bio = "run"
        
        // When
        viewController.setupProfileDetails(name: name, login: login, bio: bio)
        
        // Then
        XCTAssertEqual(viewController.nameLabel, name)
        XCTAssertEqual(viewController.loginNameLabel, login)
        XCTAssertEqual(viewController.descriptionLabel, bio)
    }
}
