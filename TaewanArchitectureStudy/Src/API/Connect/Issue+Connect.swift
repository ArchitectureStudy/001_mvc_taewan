//
//  Issue+Connect.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 9..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import Alamofire

extension Model.Issue {
    
    @discardableResult
    static func list(user: String, repo: String, page: Int? = nil, completion: @escaping (Result<[Model.Issue]>) ->Void) -> DataRequest {
        return Router.Repository
            .issues(user: user, repo: repo, page: page)
            .responseCollection { (response: DataResponse<[Model.Issue]>) in
                completion(response.result)
        }
    }
    
    @discardableResult
    static func show(user: String, repo: String, number: Int, completion: @escaping (Result<Model.Issue>) ->Void) -> DataRequest {
        return Router.Repository
            .issue(user: user, repo: repo, number: number)
            .responseObject { (response: DataResponse<Model.Issue>) in
                completion(response.result)
        }

    }
}



