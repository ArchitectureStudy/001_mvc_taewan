//
//  URLRequestConvertible+Rx.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 6..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift


extension Reactive where Base: URLRequestConvertible {
    func requestObject<T: ResponseObjectSerializable>() ->  Observable<T>  {
        return Observable<T>.create { observer -> Disposable in
            let request = Alamofire.request(self.base)
                .validate()
                .responseObject { (response: DataResponse<T>) in
                    switch response.result {
                    case .failure(let error):
                        observer.onError(error)
                    case .success(let value):
                        observer.onNext(value)
                    }
                    observer.onCompleted()
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func requestCollection<T: ResponseObjectSerializable>() ->  Observable<[T]>  {
        return Observable<[T]>.create { (observer) -> Disposable in
            
            let request = Alamofire.request(self.base)
                .validate()
                .responseCollection { (response: DataResponse<[T]>) in
                    switch response.result {
                    case .failure(let error):
                        observer.onError(error)
                    case .success(let value):
                        observer.onNext(value)
                    }
                    observer.onCompleted()
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

