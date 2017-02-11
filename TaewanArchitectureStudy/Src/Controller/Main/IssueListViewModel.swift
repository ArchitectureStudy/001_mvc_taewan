//
//  IssueListViewModel.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 2. 11..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation

protocol IssueListViewModelProtocol: class {
    
    //input
    func newIssueDidTap()
    func itemDidSelect(indexPath: IndexPath)

    
    //output
    
}


class IssueListViewModel: IssueListViewModelProtocol {
    
    func newIssueDidTap() {
        
    }
    
    func itemDidSelect(indexPath: IndexPath) {
        
    }
    
    
}

