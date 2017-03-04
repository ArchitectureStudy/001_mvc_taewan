//
//  IssueDetailViewModel.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 3. 4..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources



//typealias IssueListSection = SectionModel<Void, IssueCellViewModelType>

protocol IssueDetailViewModelType: class, ViewModelType {
    
  
}


class IssueDetailViewModel: NSObject, IssueDetailViewModelType {
    
    init(config: Router.RepositoryConfig, issue: IssueModelType) {
        
        
        
        super.init()
        
        
    }
    
    
    
    
}

