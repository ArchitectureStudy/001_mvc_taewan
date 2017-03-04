//
//  CommentsModel.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 1. 21..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation


import Foundation
import Alamofire

    public class CommentService: ModelLoadable {
        private var issueModel: IssueService
        
        public var page: Int = 1
        
        public private(set) var datas: [Model.Comment] = []
        
        init(issueModel: IssueService) {
            self.issueModel = issueModel
        }
        
        @discardableResult
        public func refresh() -> DataRequest {
            self.page = 1
            let config = issueModel.config
            
            return Router.comments(config: config, page: page)
                .responseCollection { [unowned self] (response: DataResponse<[Model.Comment]>) in
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
        public func create(body: String) -> DataRequest {
            let config = issueModel.config
            return Router.createComment(config: config, body: body)
                .responseObject { [unowned self] (response: DataResponse<Model.Comment>) in
                    switch response.result {
                    case .success(let value):
                        self.datas.append(value)
                    case .failure(let error):
                        debugPrint(error)
                    }
                    
            }
        }
        
    }


