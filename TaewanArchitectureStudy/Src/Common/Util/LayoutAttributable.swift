//
//  LayoutAttributable.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 2. 11..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import UIKit

protocol LayoutEistimatable: class {
    static var eistimatedLayout: [IndexPath: CGSize] { get set }
    static func eistimatedSizeReset(indexPath: IndexPath?)
}

extension LayoutEistimatable where Self: UICollectionViewCell {
    static func eistimatedSizeReset(indexPath: IndexPath? = nil) {
        if let key = indexPath {
            eistimatedLayout[key] = nil
        } else {
            eistimatedLayout = [:]
        }
    }
    
    func eistimateLayoutAttributes(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if layoutAttributes.isHidden {
            return layoutAttributes
        }
        
        if let layoutSize = Self.eistimatedLayout[layoutAttributes.indexPath] {
            layoutAttributes.size = layoutSize
        } else {
            layoutAttributes.size = contentView.systemLayoutSizeFitting(
                layoutAttributes.size,
                withHorizontalFittingPriority: UILayoutPriorityRequired,
                verticalFittingPriority: UILayoutPriorityDefaultLow)
            Self.eistimatedLayout[layoutAttributes.indexPath] = layoutAttributes.size
        }
        return layoutAttributes
    }
    
}
