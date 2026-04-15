//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 27.02.2026.
//

import UIKit

final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    private var alertPresenter = ResultAlertPresenter()
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(resource: .navBackButton)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(resource: .navBackButton)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = DSColor.ypBlack
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        
        fetchOAuthToken(code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success:
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print("Ошибка при аутентификации: \(error.localizedDescription)")
                self.showAuthErrorAlert()
                
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

extension AuthViewController {
    private func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        oauth2Service.fetchOAuthToken(code) { result in
            completion(result)
        }
    }
}

extension AuthViewController {
    func showAuthErrorAlert() {
        
        let model = AlertModel(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            actions: [
                AlertActionModel(
                    title: "Оk",
                    style: .default,
                    completion: nil)
            ]
        )
        alertPresenter.show(in: self, model: model)
    }
}
