//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 11.03.2026.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    
    private(set) var profile: Profile?
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private var task: URLSessionTask?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        task?.cancel()
        
        guard let request = makeProfileRequest(authToken: token) else {
            print("❌ Invalid request: \(NetworkError.invalidRequest)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let profileResponse):
                let profile = Profile(userName: profileResponse.userName,
                                      name: profileResponse.name,
                                      bio: profileResponse.bio ?? "")
                
                self.profile = profile
                completion(.success(profile))
                
            case .failure(let error):
                print("[fetchProfile]: Ошибка запроса: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeProfileRequest(authToken: String) -> URLRequest? {
        var urlComponents = URLComponents(string: Constants.defaultBaseURLString)
        urlComponents?.path += "/me"
        
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
