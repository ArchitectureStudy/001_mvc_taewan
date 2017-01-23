//
//  IssueDetailPresenter.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 1. 21..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation


protocol IssueDetailPresenterDelegate {
    func issueDidLoaded()
    func createdComment()
}


class IssueDetailPresenter: NSObject {
    var delegate: IssueDetailPresenterDelegate?
    let model: Model.IssueModel
    
    init?(config: Router.IssueConfig?) {
        guard let issue = config else { return nil }
        self.model = Model.IssueModel(config: issue)
        super.init()
    }
    
    func refresh(withComment: Bool = true) {
        model.refresh().response { [weak self] _ in
            self?.delegate?.issueDidLoaded()
            if withComment {
                self?.refreshComments()
            }
        }
    }
    
    func create(comment: String) {
        model.comments.create(body: comment).response { [weak self] _ in
            self?.delegate?.createdComment()
            self?.refresh(withComment: false)
        }
    }
    
    private func refreshComments() {
        model.comments.refresh().response { [weak self] _ in
            self?.delegate?.issueDidLoaded()
        }
    }    
    
}
