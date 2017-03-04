//
//  IssueModel.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 16..
//  Copyright © 2017년 taewankim. All rights reserved.
//
//  Service는 서버의 상태와 동일하게 구성해주자! 가공없이!
//

import Foundation
import Alamofire
import RxSwift


/// Service에서도 Rx를 쓸까 말까 고민을 했는데... 
/// 음... 로드 방식 자체를 Rx를 사용했기때문에 그냥 여기서도 쓰기로!!
public protocol IssueListServiceType {
    // MARK: Property
    var page: Int { get }
    
    // MARK: Input
    var refresh: PublishSubject<Void> { get }
    var loadMore: PublishSubject<Void> { get }
    
    // MARK: Output
    var dataSource: Variable<[Model.Issue]> { get }
}



public class IssueListService: NSObject, IssueListServiceType {
    public static let updateIssue: PublishSubject<Model.Issue> = PublishSubject<Model.Issue>()
    
    public let config: Router.RepositoryConfig
    
    public private(set) var page: Int = 1
    
    public let refresh: PublishSubject<Void> = PublishSubject<Void>()
    public let loadMore: PublishSubject<Void> = PublishSubject<Void>()
    
    public let dataSource: Variable<[Model.Issue]> = Variable([])
    
    init(config: Router.RepositoryConfig) {
        self.config = config
        super.init()
        rxSetup()
    }
    
    private func rxSetup() {
        //일치 Model.Issue 업데이트
        _ = IssueListService
            .updateIssue
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { [unowned self] issue in
                guard let index = self.dataSource.value.index(of: issue) else { return }
                self.dataSource.value[index] = issue
            })
        
        
        let config = self.config
        
        _ = refresh
            .takeUntil(rx.deallocated)
            .do(onNext: { [unowned self] _ in
                self.page = 1
            }).flatMap { _ -> Observable<[Model.Issue]> in
                Router.issues(config: config, page: nil).dataRequest.rx.responseCollection()
            }.subscribe(onNext: { [unowned self] (value: [Model.Issue]) in
                self.dataSource.value = value
            })
        
        _ = loadMore
            .takeUntil(rx.deallocated)
            .map { [unowned self] in
                self.page += 1
                return self.page
            }.flatMap { page -> Observable<[Model.Issue]> in
                Router.issues(config: config, page: page).dataRequest.rx.responseCollection()
            }.subscribe(onNext: { [unowned self] (value: [Model.Issue]) in
                self.dataSource.value += value
            })
    }
    
}
