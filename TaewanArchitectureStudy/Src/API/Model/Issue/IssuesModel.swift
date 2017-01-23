//
//  IssueModel.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 16..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import Alamofire

extension Notification.Name {
    static let IssuesModelRefresh = Notification.Name("IssuesModelRefresh")
}

extension Model {
    public class IssuesModel: PaginationModelLoadable {
        public private(set) var config: Router.RepositoryConfig
        public var page: Int = 1
        
        public private(set) var datas: [DataObject.Issue] = []
        
        init(config: Router.RepositoryConfig) {
            self.config = config
        }
        
        @discardableResult
        public func refresh() -> DataRequest {
            self.page = 1
            
            return Router.issues(config: config, page: nil)
                .responseCollection { [unowned self] (response: DataResponse<[DataObject.Issue]>) in
                    switch response.result {
                    case .success(let value):
                        print(value)
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

