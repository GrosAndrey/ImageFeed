//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 11.03.2026.
//

import Foundation

final class ProfileService {
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private var task: URLSessionTask?
    
    struct Profile {
        let userName: String
        let name: String
        let bio: String
        var loginName: String {
            return "@\(userName)"
        }
    }
    
    private var isLoading = false
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard !isLoading else { return }
        isLoading = true
        
        guard let request = makeProfileRequest(authToken: token) else {
            isLoading = false
            print("❌ Invalid request: \(NetworkError.invalidRequest)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task = session.data(for: request) { [weak self] result in
            guard let self else { return }
            
            defer {
                self.isLoading = false
                self.task = nil
            }
            
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
                    
                    completion(.success(profile))
                    
                } catch {
                    print("❌ Decoding error while parsing OAuthTokenResponseBody: \(error)")
                    completion(.failure(NetworkError.decodingError(error)))
                }
                
            case .failure(let error):
                print("🌐 Network error while fetching OAuth token: \(error)")
                completion(.failure(error))
            }
        }
        task?.resume()
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
