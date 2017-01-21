//
//  IssueCommentCell.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 16..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import UIKit
import NibDesignable

class IssueCommentCell: NibDesignableCollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var commentContainerView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
}



// MARK: - Setup
extension IssueCommentCell {
    func setup() {
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.midX
        
        commentContainerView.clipsToBounds = true
        commentContainerView.layer.cornerRadius = 2
        commentContainerView.layer.borderColor = commentContainerView.backgroundColor?.cgColor
        commentContainerView.layer.borderWidth = 1
    }
}

extension IssueCommentCell: DataObjectUpdatable {
    func update(data: DataObject.Comment, withImage: Bool = false) {
        if let url = data.user.avatarURL, withImage {
            avatarImageView.af_setImage(withURL: url)
        }
        
        let createdAt = data.createdAt?.string(dateFormat: "DD MMM yyyy") ?? "-"
        infoLabel.text = "\(data.user.login) commented on \(createdAt)"
        bodyLabel.text = data.body
    }
}
