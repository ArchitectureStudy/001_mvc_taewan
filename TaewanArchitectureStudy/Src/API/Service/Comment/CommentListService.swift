//
//  CommentsModel.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 1. 21..
//  Copyright © 2017년 taewankim. All rights reserved.
//


import Foundation
import Alamofire
import RxSwift

public protocol CommentListServiceType {
    
    
    // Property
    var page: Int { get }
    
    // Input
    var refresh: PublishSubject<Void> { get }
    var loadMore: PublishSubject<Void> { get }
    
    // Data
    var dataSource: Variable<[Model.Comment]> { get }
}



public class CommentListService: NSObject, CommentListServiceType {
    
    public private(set) var page: Int = 0
    
    // MARK: Input
    public let refresh: PublishSubject<Void> = PublishSubject()
    public let loadMore: PublishSubject<Void> = PublishSubject()
    
    // MARK: Data
    public let dataSource: Variable<[Model.Comment]> = Variable([])
    
    init(_ config: Router.IssueConfig) {
        super.init()
        
        
        _ = refresh
            .do(onNext: { [unowned self] _ in
                self.page = 1
            }).flatMap { _ -> Observable<[Model.Comment]> in
                Router.comments(config: config, page: nil).dataRequest.rx.responseCollection()
            }.takeUntil(rx.deallocated)
            .subscribe(onNext: { [unowned self] (value: [Model.Comment]) in
                self.dataSource.value = value
            })
        
        _ = loadMore
            .map { [unowned self] in
                self.page += 1
                return self.page
            }.flatMap { page -> Observable<[Model.Comment]> in
                Router.comments(config: config, page: page).dataRequest.rx.responseCollection()
            }.takeUntil(rx.deallocated)
            .subscribe(onNext: { [unowned self] (value: [Model.Comment]) in
                self.dataSource.value += value
            })
        

    }
//    private var issueModel: IssueDetailService
    
//    public var page: Int = 1
    
//    public private(set) var datas: [Model.Comment] = []
    
//    init(issueModel: IssueDetailService) {
//        self.issueModel = issueModel
//    }
    
//    @discardableResult
//    public func refresh() -> DataRequest {
//        self.page = 1
//        
////        let config = issueModel.config
//        
//        return Router.comments(config: config, page: page)
//            .responseCollection { [unowned self] (response: DataResponse<[Model.Comment]>) in
//                switch response.result {
//                case .success(let value):
//                    self.datas = value
//                    self.page += 1
//                case .failure(let error):
//                    debugPrint(error)
//                }
//        }
//    }
//    
//    @discardableResult
//    public func create(body: String) -> DataRequest {
////        let config = issueModel.config
//        return Router.createComment(config: config, body: body)
//            .responseObject { [unowned self] (response: DataResponse<Model.Comment>) in
//                switch response.result {
//                case .success(let value):
//                    self.datas.append(value)
//                case .failure(let error):
//                    debugPrint(error)
//                }
//                
//        }
//    }
    
}


