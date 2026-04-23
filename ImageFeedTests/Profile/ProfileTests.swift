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
    
    func testPresenterPassesCorrectProfileDataToView() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let service = ProfileServiceMock()
        
        service.profile = Profile(
            userName: "test",
            name: "Andrey Groshev",
            bio: "run"
        )
        
        let presenter = ProfilePresenter(profileService: service)
        presenter.view = viewController
        
        // When
        presenter.updateProfileDetails()
        
        // Then
        XCTAssertEqual(viewController.nameLabel, "Andrey Groshev")
        XCTAssertEqual(viewController.loginNameLabel, "@test")
        XCTAssertEqual(viewController.descriptionLabel, "run")
    }
}
