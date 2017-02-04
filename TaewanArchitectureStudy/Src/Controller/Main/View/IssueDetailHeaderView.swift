//
//  IssueDetailHeaderView.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 1. 21..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import UIKit

class IssueDetailHeaderView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var commentContainerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var commentInfoLabel: UILabel!
    @IBOutlet weak var commentBodyLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        print("awakeFromNib")
    }
}


// MARK: - setup
extension IssueDetailHeaderView {
    func setup() {
        stateButton.clipsToBounds = true
        stateButton.layer.cornerRadius = 2
        
        stateButton.setTitle(DataObject.Issue.State.open.display, for: .normal)
        stateButton.setBackgroundImage(UIColor.opened.toImage(), for: .normal)
        stateButton.setTitle(DataObject.Issue.State.close.display, for: .selected)
        stateButton.setBackgroundImage(UIColor.closed.toImage(), for: .selected)
        
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.midX
        
        commentContainerView.clipsToBounds = true
        commentContainerView.layer.cornerRadius = 2
        commentContainerView.layer.borderColor = commentContainerView.backgroundColor?.cgColor
        commentContainerView.layer.borderWidth = 1
    }
    
 
}

extension IssueDetailHeaderView: DataObjectUpdatable {
    func update(data: DataObject.Issue, withImage: Bool = true) {
        
        let createdAt = data.createdAt?.string(dateFormat: "DD MMM yyyy") ?? "-"
        titleLabel.text = data.title
        stateButton.isSelected = data.state == .close
        infoLabel.text = "\(data.user.login) \(data.state.display) this issue on \(createdAt) · \(data.comments) comments"
        
        //body
        if let url = data.user.avatarURL, withImage {
            avatarImageView.af_setImage(withURL: url)
        }
        commentInfoLabel.text = "\(data.user.login) commented on \(createdAt)"
        commentBodyLabel.text = data.body
    }
    
}

