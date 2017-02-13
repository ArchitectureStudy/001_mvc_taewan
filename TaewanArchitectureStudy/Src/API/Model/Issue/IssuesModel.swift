//
//  IssueModel.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 16..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import Alamofire


extension Model {
    public class IssueListModel: NSObject, PaginationModelLoadable {
        public fileprivate(set) var config: Router.RepositoryConfig
        public var page: Int = 1
        
        public fileprivate(set) var datas: [DataObject.Issue] = []
        
        init(config: Router.RepositoryConfig) {
            self.config = config
            super.init()
            addNotifications()
        }
        
        deinit {
            removeNotifications()
        }
        
        @discardableResult
        public func refresh() -> DataRequest {
            self.page = 1
            
            return Router.issues(config: config, page: nil)
                .responseCollection { [unowned self] (response: DataResponse<[DataObject.Issue]>) in
                    switch response.result {
                    case .success(let value):
                        self.datas = value
                        self.page += 1
                    case .failure(let error):
                        debugPrint(error)
                    }
            }
        }
        
        @discardableResult
        public func loadMore() -> DataRequest {
            return Router.issues(config: config, page: self.page)
                .responseCollection { [unowned self] (response: DataResponse<[DataObject.Issue]>) in
                    switch response.result {
                    case .success(let value):
                        self.datas += value
                        self.page += 1
                    case .failure(let error):
                        debugPrint(error)
                    }
            }
        }//load
        
    }
    
}


extension Model.IssueListModel {
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateIssueModel), name: .IssueModelRefresh, object: nil)
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateIssueModel(_ notification: Notification) {
        guard let model = notification.object as? Model.IssueModel,
            let userInfo = notification.userInfo else { return }
        //config 내용이 다르면 아무작업도 안합니당
        guard let issue = userInfo[Notification.Key.IssuesModel] as? DataObject.Issue,
            self.config == model.config.repository else { return }
        let len = self.datas.count
        for i in 0..<len {
            if self.datas[i].id == issue.id {
                self.datas[i] = issue
                return
            }
        }
    }

}
