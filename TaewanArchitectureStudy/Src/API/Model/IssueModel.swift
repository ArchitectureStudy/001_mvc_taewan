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
        
        init(user: String, repo: String, number: Int) {
            self.user = user
            self.repo = repo
            self.number = number
        }
        
        
        public private(set) var issue: DTO.Issue?
        
        func refresh() -> DataRequest {
            return Router.Repository
                .issue(user: user, repo: repo, number: number)
                .responseObject { (response: DataResponse<DTO.Issue>) in
                    switch response.result {
                    case .success(let value):
                        self.issue = value
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
        }
        
        
        func comment(body: String) {
            
        }
    }
    
}
