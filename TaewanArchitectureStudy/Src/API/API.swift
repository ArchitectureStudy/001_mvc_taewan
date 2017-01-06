//
//  API.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 6..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import Alamofire

fileprivate let baseURLString: String = "https://api.github.com"



/// Model
public struct Model {
    /// API/Model/* 폴더에 만들어서 사용한다.
}



/// Router
public enum Router: RouterRequestConvertible {
    case root
    
    var rawString: String { return "" }
    
    var result: (path: String, parameters: [String: Any]?)  {
        return (path: "", parameters: nil)
    }
}



/// RouterRequestConvertible
protocol RouterRequestConvertible: URLRequestConvertible {
    var rawString: String { get }
    var method: Alamofire.HTTPMethod { get }
    var result: (path: String, parameters: [String: Any]?) { get }
}

extension RouterRequestConvertible {
    
    
    /// 기본적으로 전부 GET
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    
    /// rawString을 이용해서 각자 쉽게좀 쓰려고 만든것.
    ///
    /// - Returns: URLRequest
    /// - Throws: AFError(Alamofire Error)
    public func asURLRequest() throws -> URLRequest {
        let baseURL = try baseURLString.asURL()
        var request: URLRequest
        
        if rawString.isEmpty {
            request = URLRequest(url: baseURL.appendingPathComponent(result.path))
        } else {
            let appendingPath = "/\(rawString)/\(result.path)".replacingOccurrences(of: "//", with: "/")
            request = URLRequest(url: baseURL.appendingPathComponent(appendingPath))
        }
        
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
}

