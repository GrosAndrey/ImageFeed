//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 03.04.2026.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
