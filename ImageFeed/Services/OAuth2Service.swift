//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 03.03.2026.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let session: URLSession
    private let decoder = JSONDecoder()
    private let storage = OAuth2TokenStorage()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("❌ Invalid request: \(NetworkError.invalidRequest)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = session.data(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let tokenResponse = try self.decoder.decode(
                        OAuthTokenResponseBody.self,
                        from: data
                    )
                    let token = tokenResponse.accessToken
                    self.storage.token = token
                    completion(.success(token))
                    
                } catch {
                    print("❌ Decoding error while parsing OAuthTokenResponseBody: \(error)")
                    completion(.failure(NetworkError.decodingError(error)))
                }
                
            case .failure(let error):
                print("🌐 Network error while fetching OAuth token: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]
        
        guard let authTokenUrl = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }
}
