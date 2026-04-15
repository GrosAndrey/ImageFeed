//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 15.03.2026.
//

import UIKit

// MARK: - ResultAlertPresenter

final class ResultAlertPresenter {
    
    // MARK: - Public Methods
    
    func show(in vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        model.actions.forEach { actionModel in
            let action = UIAlertAction(
                title: actionModel.title,
                style: actionModel.style
            ) { _ in
                actionModel.completion?()
            }
            
            alert.addAction(action)
        }
        vc.present(alert, animated: true, completion: nil)
    }
}
