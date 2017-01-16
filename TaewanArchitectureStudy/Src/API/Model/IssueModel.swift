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
    public class IssuesModel {
        public var user: String
        public var repo: String
        
        init(user: String, repo: String) {
            self.user = user
            self.repo = repo
        }
        
        private var page: Int = 1
        
        public private(set) var list: [DTO.Issue] = []
        
        func refresh() -> DataRequest {
            self.page = 1
            return Router.Repository
                .issues(user: user, repo: repo, page: nil)
                .responseCollection { (response: DataResponse<[DTO.Issue]>) in
                    switch response.result {
                    case .success(let value):
                        self.list = value
                        self.page += 1
                    case .failure(let error):
                        debugPrint(error)
                    }
            }
        }
        
        func loadMore() -> DataRequest {
            return Router.Repository
                .issues(user: user, repo: repo, page: self.page)
                .responseCollection { (response: DataResponse<[DTO.Issue]>) in
                    switch response.result {
                    case .success(let value):
                        self.list += value
                        self.page += 1
                    case .failure(let error):
                        debugPrint(error)
                    }
            }
        }//load
        
    }
    
}
