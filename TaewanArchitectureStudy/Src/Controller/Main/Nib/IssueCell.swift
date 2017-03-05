//
//  IssueCell.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 1. 8..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import UIKit
import NibDesignable

class IssueCell: NibDesignableCollectionViewCell, LayoutEstimatable {
    static var estimatedLayout: [IndexPath: CGSize] = [:]
  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return self.estimateLayoutAttributes(layoutAttributes)
    }
}

extension IssueCell: Configurable, AnyConfigurable {
    
    func configure(_ viewModel: IssueCellModelType?) {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.title
        subLabel.text = viewModel.subLabel
        stateButton.isSelected = !viewModel.isOpened
        commentButton.isHidden = viewModel.isCommentHidden
        commentButton.setTitle(viewModel.comments, for: .normal)
    }
}


class Test: UITableViewCell {
    var bottomSpacing: CGFloat = 0
    
    
    override var frame: CGRect {
        get { return super.frame }
        set {
            
            var frame = newValue
            frame.origin.y += 4
            frame.size.height -= 2 * 4
            super.frame = frame
        }
    }
//    override var frame: CGRect {
//        
//    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    self.
//        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(10, 10, 10, 10))
//    }
}
