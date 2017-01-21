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
    public class IssuesModel: PaginationModelLoadable {
        public private(set) var config: RepositoryConfig
        public var page: Int = 1
        
        public private(set) var datas: [DataObject.Issue] = []
        
        init(config: RepositoryConfig) {
            self.config = config
        }
        
        @discardableResult
        public func refresh() -> DataRequest {
            self.page = 1
            return Router.issues(user: config.user, repo: config.repo, page: nil)
                .responseCollection { (response: DataResponse<[DataObject.Issue]>) in
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
            return Router.issues(user: config.user, repo: config.repo, page: self.page)
                .responseCollection { (response: DataResponse<[DataObject.Issue]>) in
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

