//
//  RepositoryIssueCell.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 1. 8..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import UIKit
import NibDesignable

class RepositoryIssueCell: NibDesignableCollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    @IBOutlet weak var stateButton: UIButton!
    
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var sub: String? {
        get { return subLabel.text }
        set { subLabel.text = newValue }
    }
    
    var state: Model.Issue.State? = nil {
        didSet {
            stateButton.isSelected = state == .close
        }
    }
    
}
