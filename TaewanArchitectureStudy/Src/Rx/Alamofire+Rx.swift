//
//  Alamofire+Rx.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 3. 4..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import RxSwift

extension DataRequest: ReactiveCompatible {}

extension Reactive where Base: DataRequest {
    public func responseSwiftyJSON() -> Observable<JSON> {
        return Observable.create { observer -> Disposable in
            let request = self.base.responseSwiftyJSON { (response: DataResponse<JSON>) in
                switch response.result {
                case .failure(let error):
                    observer.onError(error)
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public func responseObject<T: ResponseObjectSerializable>() -> Observable<T> {
        return Observable.create { observer -> Disposable in
            let request = self.base.responseObject { (response: DataResponse<T>) in
                switch response.result {
                case .failure(let error):
                    observer.onError(error)
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public func responseCollection<T: ResponseObjectSerializable>() -> Observable<[T]> {
        return Observable.create { observer -> Disposable in
            let request = self.base.responseCollection { (response: DataResponse<[T]>) in
                switch response.result {
                case .failure(let error):
                    observer.onError(error)
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }

}
