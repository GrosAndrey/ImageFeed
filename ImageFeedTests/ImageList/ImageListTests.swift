//
//  ImageListTests.swift
//  ImageFeedTests
//
//  Created by Андрей Грошев on 23.04.2026.
//

import XCTest
@testable import ImageFeed

final class ImageListTests: XCTestCase {
    
    @MainActor
    func testViewControllerCallsViewDidLoad() {
        // Given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    @MainActor
    func testTableViewShowsCorrectNumberOfRows() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        
        presenter.photos = Array(
            repeating: Photo(
                id: "1",
                size: CGSize(width: 100, height: 100),
                createdAt: nil,
                welcomeDescription: nil,
                thumbImageURL: "thumb",
                largeImageURL: "large",
                isLiked: false
            ),
            count: 5
        )
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        guard let dataSource = viewController.tableView?.dataSource else {
            XCTFail("dataSource is nil")
            return
        }
        
        let numberOfRows = dataSource.tableView(
            viewController.tableView ?? UITableView(),
            numberOfRowsInSection: 0
        )
        
        XCTAssertEqual(numberOfRows, 5)
    }
    
    @MainActor
    func testWillDisplayCellCallsPresenter() {
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        
        presenter.photos = Array(
            repeating: Photo(
                id: "1",
                size: CGSize(width: 100, height: 100),
                createdAt: nil,
                welcomeDescription: nil,
                thumbImageURL: "thumb",
                largeImageURL: "large",
                isLiked: false
            ),
            count: 1
        )
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = UITableViewCell()
        
        viewController.tableView(
            viewController.tableView ?? UITableView(),
            willDisplay: cell,
            forRowAt: indexPath
        )
        
        XCTAssertTrue(presenter.willDisplayCellCalled)
        XCTAssertEqual(presenter.willDisplayCellIndexPathCalled, indexPath)
    }
}
