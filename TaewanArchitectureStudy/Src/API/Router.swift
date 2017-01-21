//
//  Router.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 1. 21..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

fileprivate let baseURLString: String = "https://api.github.com"

public enum Router {
    case issues(user: String, repo: String, page: Int?)
    case issue(user: String, repo: String, number: Int)
    case comments(user: String, repo: String, number: Int)
    
    
    var method: Alamofire.HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var result: (path: String, parameters: [String: Any]?)  {
        switch self {
        case .issues(let user, let repo, let page):
            var parameters: [String: Any] = [:]
            if let page = page {
                parameters["page"] = page
            }
            return (path: "repos/\(user)/\(repo)/issues", parameters: parameters)
        case .issue(let user, let repo, let number):
            return (path: "repos/\(user)/\(repo)/issues/\(number)", parameters: nil)
        case .comments(let user, let repo, let number):
            return (path: "repos/\(user)/\(repo)/issues/\(number)/comments", parameters: nil)
        }
    }    
}


extension Router: URLRequestConvertible {
    /// - Returns: URLRequest
    /// - Throws: AFError(Alamofire Error)
    public func asURLRequest() throws -> URLRequest {
        let baseURL = try baseURLString.asURL()
        var request: URLRequest = URLRequest(url: baseURL.appendingPathComponent(result.path))
        
        request.httpMethod = self.method.rawValue
        
        switch  method {
        case .post, .patch, .put:
            request = try JSONEncoding.default.encode(request, with: result.parameters)
        default:
            /// parameters가 있고 0개 이상일때는 URLEncoding을 해주자!
            if let parameters = result.parameters, 0 < parameters.count {
                request = try URLEncoding.default.encode(request, with: parameters)
            }
        }
        return request
    }
    
    public func responseSwiftyJSON(_ completionHandler: @escaping (DataResponse<JSON>) -> Void) -> DataRequest {
        return Alamofire.request(self).responseSwiftyJSON(completionHandler)
    }
    
    public func responseObject<T: ResponseObjectSerializable>(_ completionHandler: @escaping (DataResponse<T>) -> Void) -> DataRequest {
        return Alamofire.request(self).responseObject(completionHandler)
    }
    
    public func responseCollection<T: ResponseObjectSerializable>(_ completionHandler: @escaping (DataResponse<[T]>) -> Void) -> DataRequest {
        return Alamofire.request(self).responseCollection(completionHandler)
    }
    
}
