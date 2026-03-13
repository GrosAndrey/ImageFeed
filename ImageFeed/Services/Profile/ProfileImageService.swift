//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 13.03.2026.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    private(set) var avatarURL: String?
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private var task: URLSessionTask?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        
        guard let request = makeUserRequest(userName: username) else {
            print("❌ Invalid request: \(NetworkError.invalidRequest)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = session.data(for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let userResponse = try self.decoder.decode(
                        UserResult.self,
                        from: data
                    )
                    
                    let avatarURL = userResponse.profileImage.small
                    
                    self.avatarURL = avatarURL
                    completion(.success(avatarURL))
                    
                } catch {
                    print("❌ Decoding error while parsing OAuthTokenResponseBody: \(error)")
                    completion(.failure(NetworkError.decodingError(error)))
                }
                
            case .failure(let error):
                print("🌐 Network error while fetching OAuth token: \(error)")
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func makeUserRequest(userName: String) -> URLRequest? {
        var urlComponents = URLComponents(string: Constants.defaultBaseURLString)
        urlComponents?.path += "/users/:username"
        
        guard let urlComponents else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        guard let profileUrl = urlComponents.url else {
            return nil
        }
        
        guard let authToken = OAuth2TokenStorage.shared.token else {
            return nil
        }
        
        var request = URLRequest(url: profileUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
