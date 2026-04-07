//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 13.02.2026.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    var imageURL: URL?
    
    private let minimumZoomScale = 0.1
    private let maximumZoomScale = 1.25
    private let placeholderImageView = UIImageView()
    private let alertPresenter = ResultAlertPresenter()
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupPlaceholder()
        loadImage()
    }
    
    private func setupScrollView() {
        scrollView.minimumZoomScale = minimumZoomScale
        scrollView.maximumZoomScale = maximumZoomScale
        scrollView.delegate = self
    }
    
    private func setupPlaceholder() {
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        placeholderImageView.contentMode = .scaleAspectFit
        placeholderImageView.image = UIImage(resource: .stubLogo)
        
        view.addSubview(placeholderImageView)
        
        NSLayoutConstraint.activate([
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 100),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func loadImage() {
        guard let url = imageURL else { return }
        
        placeholderImageView.isHidden = false
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(
            with: url,
            options: [
                .scaleFactor(UIScreen.main.scale)
            ]) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                guard let self else { return }
                
                self.placeholderImageView.isHidden = true
                
                switch result {
                case .success(let value):
                    let image = value.image
                    
                    self.imageView.frame.size = image.size
                    self.rescaleAndCenterImageInScrollView(image: image)
                    
                case .failure:
                    self.showError()
                }
            }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        guard imageSize.width > 0,
              imageSize.height > 0 else {
            assertionFailure("Image size is zero")
            return
        }
        
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func showError() {
        let model = AlertModel(
            title: "Что-то пошло не так. ",
            message: "Попробовать ещё раз?",
            actions: [
                AlertActionModel(
                    title: "Не надо",
                    style: .default,
                    completion: nil),
                AlertActionModel(
                    title: "Повторить",
                    style: .default,
                    completion: { self.loadImage() })
            ]
        )
        alertPresenter.show(in: self, model: model)
    }
    
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
