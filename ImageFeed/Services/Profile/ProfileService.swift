//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 11.03.2026.
//

import Foundation

struct Profile {
    let userName: String
    let name: String
    let bio: String
    var loginName: String {
        return "@\(userName)"
    }
}

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        task?.cancel()
        
        guard let request = makeProfileRequest(authToken: token) else {
            print("❌ Invalid request: \(NetworkError.invalidRequest)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = session.data(for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let profileResponse = try self.decoder.decode(
                        ProfileResult.self,
                        from: data
                    )
                    
                    let profile = Profile(userName: profileResponse.userName,
                                          name: profileResponse.name,
                                          bio: profileResponse.bio ?? "")
                    
                    self.profile = profile
                    completion(.success(profile))
                    
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
