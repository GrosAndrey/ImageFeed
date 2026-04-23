//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Андрей Грошев on 23.04.2026.
//

import Foundation
import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    
    var presenter: ImagesListPresenterProtocol?
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) { }
    
    func showError() { }
    
    func updateLike(at indexPath: IndexPath) { }
}
