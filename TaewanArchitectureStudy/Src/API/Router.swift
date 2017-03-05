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
    case issues(config: RepositoryConfig, page: Int?)
    case issue(config: IssueConfig)
    case comments(config: IssueConfig, page: Int?)
    
    case createComment(config: IssueConfig, body: String)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .createComment:
            return .post
        default:
            return .get
        }
    }
    
    var result: (path: String, parameters: [String: Any]?)  {
        switch self {
        case .issues(let config, let page):
            var parameters: [String: Any] = [:]
            if let page = page {
                parameters["page"] = page
            }
            return (path: "repos/\(config.user)/\(config.repo)/issues", parameters: parameters)
        case .issue(let config):
            let repository = config.repository
            return (path: "repos/\(repository.user)/\(repository.repo)/issues/\(config.number)", parameters: nil)
        case .comments(let config, let page):
            let repository = config.repository
            var parameters: [String: Any] = [:]
            if let page = page {
                parameters["page"] = page
            }
            return (path: "repos/\(repository.user)/\(repository.repo)/issues/\(config.number)/comments", parameters: parameters)
            
        case .createComment(let config, let body):
            let repository = config.repository
            return (path: "repos/\(repository.user)/\(repository.repo)/issues/\(config.number)/comments", parameters: ["body": body])
        }
    }
}




extension Router {
    static var accessToken: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "accessToken")
        }
    }
    
    static fileprivate var _manager: Alamofire.SessionManager?
    
    static var manager: Alamofire.SessionManager {
        if _manager == nil {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30 // seconds
            configuration.timeoutIntervalForResource = 30
            configuration.httpCookieStorage = HTTPCookieStorage.shared
            configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
            _manager = Alamofire.SessionManager(configuration: configuration)
        }
        
        return _manager!
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
        
        if let accessToken = Router.accessToken {
            request.setValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    public var dataRequest: DataRequest {
        return Router.manager.request(self)
    }
    
    @available(*, deprecated, message: "rx 방식으로 이용하자.")
    public func responseSwiftyJSON(_ completionHandler: @escaping (DataResponse<JSON>) -> Void) -> DataRequest {
        return Router.manager.request(self).responseSwiftyJSON(completionHandler)
    }
    
    @available(*, deprecated, message: "rx 방식으로 이용하자.")
    public func responseObject<T: ResponseObjectSerializable>(_ completionHandler: @escaping (DataResponse<T>) -> Void) -> DataRequest {
        return Router.manager.request(self).responseObject(completionHandler)
    }
    
    @available(*, deprecated, message: "rx 방식으로 이용하자.")
    public func responseCollection<T: ResponseObjectSerializable>(_ completionHandler: @escaping (DataResponse<[T]>) -> Void) -> DataRequest {
        return Router.manager.request(self).responseCollection(completionHandler)
    }
    
}
