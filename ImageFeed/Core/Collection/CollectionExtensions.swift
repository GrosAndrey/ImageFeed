//
//  CollectionExtensions.swift
//  ImageFeed
//
//  Created by Андрей Грошев on 03.04.2026.
//

import Foundation

extension Array {
    func withReplaced(itemAt index: Index, newValue: Element) -> [Element] {
        var result = self
        result[index] = newValue
        return result
    }
}
