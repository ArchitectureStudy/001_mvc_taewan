//
//  IssueCell.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 1. 8..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import UIKit
import NibDesignable

class IssueCell: NibDesignableCollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    @IBOutlet weak var stateButton: UIButton!
    
    @IBOutlet weak var commentButton: UIButton!
}


extension IssueCell: DataObjectUpdatable {

    func update(data: DataObject.Issue, withImage: Bool = false) {
        let createdAt = data.createdAt?.string(dateFormat: "DD MMM yyyy") ?? "-"
        
        titleLabel.text = data.title
        subLabel.text = "#\(data.number) \(data.state.display) on \(createdAt) by \(data.user.login)"
        stateButton.isSelected = data.state == .close
        
        commentButton.isHidden = data.comments == 0
        commentButton.setTitle("\(data.comments)", for: .normal)
    }
}
