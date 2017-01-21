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
    public class IssueModel {
        private var user: String
        private var repo: String
        private var number: Int
        
        public private(set) var issue: DataObject.Issue?
        public private(set) var comments: [DataObject.Comment] = []
        
        init(user: String, repo: String, number: Int) {
            self.user = user
            self.repo = repo
            self.number = number
        }
        
        func refresh() -> DataRequest {
            return Router.issue(user: user, repo: repo, number: number)
                .responseObject { (response: DataResponse<DataObject.Issue>) in
                    switch response.result {
                    case .success(let value):
                        self.issue = value
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
        }
        
        func refreshComments() -> DataRequest {
            return Router.comments(user: user, repo: repo, number: number)
                .responseCollection { (response: DataResponse<[DataObject.Comment]>) in
                    switch response.result {
                    case .success(let value):
                        self.comments = value
                    case .failure(let error):
                        debugPrint(error)
                    }
            }
        }
        
        func comment(body: String) {
            
        }
        
    }
    
}
