//
//  ImageListViewPresenter.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 22.04.2026.
//

import UIKit
import Kingfisher

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    
    func viewDidLoad()
    func willDisplayCell(at indexPath: IndexPath)
    func didTapLike(at indexPath: IndexPath)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    private let imagesListService = ImagesListService.shared
    private var observer: NSObjectProtocol?
    
    private(set) var photos: [Photo] = []
    
    func viewDidLoad() {
        observer = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updatePhotos()
        }
        
        fetchPhotosNextPage()
    }
    
    private func updatePhotos() {
        let oldCount = photos.count
        let newPhotos = imagesListService.photos
        let newCount = newPhotos.count
        
        photos = newPhotos
        
        view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
    }
    
    private func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage() { _ in }
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        let lastIndex = photos.count - 1
        if indexPath.row == lastIndex {
            fetchPhotosNextPage()
        }
    }
    
    func didTapLike(at indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                self.view?.updateLike(at: indexPath)
                
            case .failure:
                self.view?.showError()
            }
        }
    }
}
