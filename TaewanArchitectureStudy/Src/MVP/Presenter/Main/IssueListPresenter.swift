//
//  IssueListPresenter.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 1. 21..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation


protocol IssueListPresenterDelegate: class {
    func issueListDidLoaded()
}


class IssueListPresenter: NSObject {
    weak var delegate: IssueListPresenterDelegate?
    let service: IssueListService
    
    
    init?(config: Router.RepositoryConfig?) {
        guard let repository = config else { return nil }
        self.service = IssueListService(config: repository)
        super.init()
    }

    func refresh() {
        service.refresh().response { [weak self] _ in
            self?.delegate?.issueListDidLoaded()
        }
    }
    
    func loadMore() {
        service.loadMore().response { [weak self] _ in
            self?.delegate?.issueListDidLoaded()
        }
    }
    
}
