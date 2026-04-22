//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 30.01.2026.
//

import UIKit
import Kingfisher

protocol ImagesListViewProtocol: AnyObject {
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func showError()
    func updateLike(at indexPath: IndexPath)
}

final class ImagesListViewController: UIViewController, ImagesListViewProtocol {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var presenter: ImagesListPresenterProtocol = ImagesListPresenter()
    
    private var alertPresenter = ResultAlertPresenter()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    @IBOutlet weak private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let photo = presenter.photos[indexPath.row]
            
            guard let url = URL(string: photo.largeImageURL) else { return }
            viewController.imageURL = url
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        if oldCount != newCount {
            let indexPaths = (oldCount..<newCount).map {
                IndexPath(row: $0, section: 0)
            }
            
            tableView.performBatchUpdates {
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
    
    func updateLike(at indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell {
            let photo = presenter.photos[indexPath.row]
            cell.setIsLiked(isLiked: photo.isLiked)
        }
    }
    
    func showError() {
        let model = AlertModel(
            title: "Что-то пошло не так",
            message: "Не удалось обновить лайк",
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

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = presenter.photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplayCell(at: indexPath)
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = presenter.photos[indexPath.row]
        
        guard let url = URL(string: photo.thumbImageURL) else { return }
        
        let placeholderImage = UIImage(resource: .stubLogo)
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .scaleFactor(UIScreen.main.scale)
            ]) { result in
                switch result {
                case .success(let value):
                    print(value.image)
                    print(value.cacheType)
                    print(value.source)
                    
                case .failure(let error):
                    print(error)
                }
            }
        
        cell.dateLabel.text = dateFormatter.string(from: photo.createdAt ?? Date())
        cell.setIsLiked(isLiked: photo.isLiked)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.didTapLike(at: indexPath)
    }
}
