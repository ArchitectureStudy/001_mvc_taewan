//
//  IssueListViewModel.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 2. 11..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import RxSwift

protocol IssueListViewModelType: class, ViewModelType {
    
    var config: Router.RepositoryConfig { get }
    var service: IssueListService { get }
    //네트워크 모델도 여기에 있어야하지 않을까?
    
    //콜렉션 뷰가 여기에 있어야하나? reloadData 시키는거때문에?
    var numberOfItems: Int { get }
    var listDidLoaded: (()->Void)? { get set }
    
    //input
    func newIssueDidTap() -> UIAlertController
    
    //refresh / pull to refresh
    func refresh(sender: Any)
    func loadmore()
    
    //output
    //네비게이션 타이틀 주는거.
    //여기서 셀에 적용을 해줄까?
    
    
    
}


class IssueListViewModel: IssueListViewModelType {
    let config: Router.RepositoryConfig
    let service: IssueListService
    
    var listDidLoaded: (()->Void)? = nil
    
    var numberOfItems: Int {
        return service.datas.count
    }
    
    init(config: Router.RepositoryConfig) {
        self.config = config
        service = IssueListService(config: config)
    }
    
    func newIssueDidTap() -> UIAlertController {
        let alert = UIAlertController(title: "는 훼이크", message: "힇 속았지?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        return alert
    }
    
    @objc
    func refresh(sender: Any) {
        service.refresh().response { [weak self] _ in
            self?.listDidLoaded?()
        }
    }
    
    func loadmore() {
        service.loadMore().response { [weak self] _ in
            self?.listDidLoaded?()
        }
    }
    
}

