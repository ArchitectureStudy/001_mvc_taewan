//
//  IssueListViewModel.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 2. 11..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import UIKit

protocol IssueListViewModelProtocol: class {
    
    var config: Router.RepositoryConfig { get }
    //네트워크 모델도 여기에 있어야하지 않을까?
    
    //콜렉션 뷰가 여기에 있어야하나? reloadData 시키는거때문에?
    
    
    //input
    func newIssueDidTap() -> UIAlertController
    func itemDidSelect(indexPath: IndexPath)
    //refresh / pull to refresh
    func refresh(sender: Any)
    
    //output
    //네비게이션 타이틀 주는거.
    //여기서 셀에 적용을 해줄까?
}


class IssueListViewModel: IssueListViewModelProtocol {
    let config: Router.RepositoryConfig
    
    init(config: Router.RepositoryConfig) {
        self.config = config
    }
    
    func newIssueDidTap() -> UIAlertController {
        let alert = UIAlertController(title: "는 훼이크", message: "힇 속았지?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        return alert
    }
    
    func refresh(sender: Any) {
        
    }
    
    func itemDidSelect(indexPath: IndexPath) {
        
    }
    
    
}

