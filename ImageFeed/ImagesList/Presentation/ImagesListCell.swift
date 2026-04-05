//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 04.02.2026.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
    }
    
    func setIsLiked(isLiked: Bool) {
        let isEven = isLiked
        let imageResource: UIKit.ImageResource = isEven ? .likeButtonOn : .likeButtonOff
        let imageIcon: UIImage = UIImage(resource: imageResource)
        likeButton.setImage(imageIcon, for: .normal)
    }
    
    @IBAction func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}
