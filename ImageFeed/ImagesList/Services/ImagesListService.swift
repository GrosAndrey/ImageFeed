//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 31.03.2026.
//

import UIKit

// MARK: - ImagesListService

final class ImagesListService {
    
    // MARK: - Constants
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Singleton
    
    static let shared = ImagesListService()
    private init() {}
    
    // MARK: - Private Properties
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    private let session = URLSession.shared
    private var task: URLSessionTask?
    
    // MARK: - Public Methods
    
    func fetchPhotosNextPage(_ completion: @escaping (Result<Void, Error>) -> Void) {
        task?.cancel()
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(NSError(domain: "ImagesListService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authorization token missing"])))
            return
        }
        
        guard let request = makePhotoRequest(page: nextPage, authToken: token) else {
            print("❌ Invalid request: \(NetworkError.invalidRequest)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photosResponse):
                let newPhotos: [Photo] = photosResponse.map { photoResponse in
                    Photo(
                        id: photoResponse.id,
                        size: CGSize(width: photoResponse.width, height: photoResponse.height),
                        createdAt: photoResponse.createdAt ?? Date(),
                        welcomeDescription: photoResponse.welcomeDescription ?? "",
                        thumbImageURL: photoResponse.urlsResult.thumbImageURL,
                        largeImageURL: photoResponse.urlsResult.largeImageURL,
                        isLiked: photoResponse.isLiked
                    )
                }
                
                self.photos.append(contentsOf: newPhotos)
                self.lastLoadedPage = nextPage
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self
                )
                
                completion(.success(()))
                
            case .failure(let error):
                print("[fetchPhotosNextPage]: Ошибка запроса: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
        
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void){
        task?.cancel()
        
        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(NSError(domain: "ImagesListService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authorization token missing"])))
            return
        }
        
        guard let request = makeLikeRequest(photoId: photoId, isLike: isLike, authToken: token) else {
            print("❌ Invalid request: \(NetworkError.invalidRequest)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<LikeResponse, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                let photoResponse = response.photo
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let newPhoto = Photo(
                        id: photoResponse.id,
                        size: CGSize(width: photoResponse.width, height: photoResponse.height),
                        createdAt: photoResponse.createdAt ?? Date(),
                        welcomeDescription: photoResponse.welcomeDescription ?? "",
                        thumbImageURL: photoResponse.urlsResult.thumbImageURL,
                        largeImageURL: photoResponse.urlsResult.largeImageURL,
                        isLiked: photoResponse.isLiked
                    )
                    self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                }
                
                completion(.success(()))
                
            case .failure(let error):
                print("[changeLike]: Ошибка запроса: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makePhotoRequest(page: Int, authToken: String) -> URLRequest? {
        var urlComponents = URLComponents(string: Constants.defaultBaseURLString)
        urlComponents?.path += "/photos"
        
        guard var urlComponents else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page))
        ]
        
        guard let photosUrl = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: photosUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func makeLikeRequest(photoId: String, isLike: Bool, authToken: String) -> URLRequest? {
        var urlComponents = URLComponents(string: Constants.defaultBaseURLString)
        urlComponents?.path += "/photos/\(photoId)/like"
        
        guard let urlComponents else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        guard let photoUrl = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: photoUrl)
        request.httpMethod = isLike ? HTTPMethod.delete.rawValue : HTTPMethod.post.rawValue
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
