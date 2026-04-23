//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Андрей Грошев on 23.04.2026.
//

import Foundation
import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewDidLoadCalled = false
    var willDisplayCellCalled = false
    var willDisplayCellIndexPathCalled: IndexPath?
    
    var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        willDisplayCellCalled = true
        willDisplayCellIndexPathCalled = indexPath
    }
    
    func didTapLike(at indexPath: IndexPath) { }
}
