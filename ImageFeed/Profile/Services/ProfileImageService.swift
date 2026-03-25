//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 13.03.2026.
//

import Foundation

// MARK: - ProfileImageService

final class ProfileImageService {
    
    // MARK: - Constants
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - Singleton
    
    static let shared = ProfileImageService()
    private init() {}
    
    // MARK: - Public Properties
    
    private(set) var avatarURL: String?
    
    // MARK: - Private Properties
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private var task: URLSessionTask?
    
    // MARK: - Public Methods
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        
        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(NSError(domain: "ProfileImageService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authorization token missing"])))
            return
        }
        
        guard let request = makeUserRequest(userName: username, authToken: token) else {
            print("❌ Invalid request: \(NetworkError.invalidRequest)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let userResponse):
                let avatarURL = userResponse.profileImage.small
                
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": avatarURL])
                
            case .failure(let error):
                print("[fetchProfileImageURL]: Ошибка запроса: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makeUserRequest(userName: String, authToken: String) -> URLRequest? {
        var urlComponents = URLComponents(string: Constants.defaultBaseURLString)
        urlComponents?.path += "/users/\(userName)"
        
        guard let urlComponents else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        guard let profileUrl = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: profileUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
