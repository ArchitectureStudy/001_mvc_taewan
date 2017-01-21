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
}


class IssueDetailPresenter: NSObject {
    var delegate: IssueDetailPresenterDelegate?
    let model: Model.IssueModel
    
    init?(config: Model.IssueConfig?) {
        guard let issue = config else { return nil }
        self.model = Model.IssueModel(config: issue)
        super.init()
    }
    
    func refresh() {
        model.refresh().response { [weak self] _ in
            self?.delegate?.issueDidLoaded()
            self?.refreshComments()
        }
    }
    
    private func refreshComments() {
        model.comments.refresh().response { [weak self] _ in
            self?.delegate?.issueDidLoaded()
        }
    }    
    
}
