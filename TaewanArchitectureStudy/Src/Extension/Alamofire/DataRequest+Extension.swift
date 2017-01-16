//
//  DataRequest+Extension.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 6..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


enum BackendError: Error {
    case network(error: Error)
    case dataSerialization(reason: String)
    case jsonSerialization(error: Error)
    case objectSerialization(reason: String)
    case xmlSerialization(error: Error)
}


public protocol ResponseObjectSerializable {
    init(json: JSON)
}

public protocol ResponseCollectionSerializable {
    static func collection<T: ResponseObjectSerializable>(json value: JSON) -> [T]
}

public extension ResponseCollectionSerializable {
    static func collection<T: ResponseObjectSerializable>(json value: JSON) -> [T] {
        var results: [T] = []
        for json in value.arrayValue {
            let type = T(json: json)
            results.append(type)
            
        }
        return results
    }
}


extension DataRequest {
    
    public func responseVoid(_ completionHandler: @escaping (DataResponse<Void>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<Void> { request, response, data, error in
            guard error == nil else {
                DataRequest.errorMessage(response, error: error, data: data)
                return .failure(error!)
            }
            return .success()
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    
    public func responseSwiftyJSON(_ completionHandler: @escaping (DataResponse<JSON>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<JSON> { request, response, data, error in
            guard error == nil else {
                DataRequest.errorMessage(response, error: error, data: data)
                return .failure(error!)
            }
            
            let result = DataRequest
                .jsonResponseSerializer(options: .allowFragments)
                .serializeResponse(request, response, data, error)
            
            switch result {
            case .success(let value):
                if let _ = response {
                    return .success(JSON(value))
                } else {
                    let failureReason = "JSON could not be serialized into response object: \(value)"
                    let error = BackendError.objectSerialization(reason: failureReason)
                    DataRequest.errorMessage(response, error: error, data: data)
                    return .failure(error)
                }
            case .failure(let error):
                DataRequest.errorMessage(response, error: error, data: data)
                return .failure(error)
            }
        }
//        responseJSON { response in
//            switch response.result {
//            case .failure(let error):
//                break
//            case .success(let data):
//                let json = JSON(data)
//                DataRequest.se
//                    .serializeResponse(request, response, data, error)
//
//                completionHandler(.success(json))
//            }
//        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
 
    //객체 타입
    public func responseObject<T: ResponseObjectSerializable>(_ completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            guard error == nil else {
                DataRequest.errorMessage(response, error: error, data: data)
                return .failure(error!)
            }
            
            let result = DataRequest
                .jsonResponseSerializer(options: .allowFragments)
                .serializeResponse(request, response, data, error)
            
            switch result {
            case .success(let value):
                if let _ = response {
                    let responseObject = T(json: JSON(value))
                    return .success(responseObject)
                } else {
                    let failureReason = "JSON could not be serialized into response object: \(value)"
                    let error = BackendError.objectSerialization(reason: failureReason)
                    DataRequest.errorMessage(response, error: error, data: data)
                    return .failure(error)
                }
            case .failure(let error):
                DataRequest.errorMessage(response, error: error, data: data)
                return .failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    
    
    public func responseCollection<T: ResponseObjectSerializable>(_ completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self {
        
        let responseSerializer = DataResponseSerializer<[T]> { request, response, data, error in
            
            guard error == nil else {
                DataRequest.errorMessage(response, error: error, data: data)
                return .failure(error!)
            }
            
            let result = DataRequest
                .jsonResponseSerializer(options: .allowFragments)
                .serializeResponse(request, response, data, error)
            
            switch result {
            case .success(let value):
                if let _ = response {
                    var results: [T] = []
                    for obj in JSON(value) {
                        let type = T(json: obj.1)
                        results.append(type)
                    }
                    return .success(results)
                } else {
                    let failureReason = "Response collection could not be serialized due to nil response"
                    let error = BackendError.objectSerialization(reason: failureReason)
                    DataRequest.errorMessage(response, error: error, data: data)
                    return .failure(error)
                }
            case .failure(let error):
                DataRequest.errorMessage(response, error: error, data: data)
                return .failure(error)
            }
        }
        
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    static func errorMessage(_ response: HTTPURLResponse?, error: Error?, data: Data?) {
        debugPrint("status: \(response?.statusCode ?? -1), error message:\(error.debugDescription)")
    }
    
}


