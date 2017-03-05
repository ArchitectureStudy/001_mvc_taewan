//
//  IssueModel.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 16..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

public protocol IssueServiceType {
    typealias UpdateDetail = (hashValue: Int, model: Model.Issue)
    static var update: PublishSubject<UpdateDetail> { get }
    
    // Input
    var refresh: PublishSubject<Void> { get }
    
    // Data
    var dataSource: Variable<Model.Issue> { get }
}

public class IssueService: NSObject, IssueServiceType {
    // MARK: - Static
    public static let update: PublishSubject<IssueServiceType.UpdateDetail> = PublishSubject()

    // MARK: - Input
    public let refresh: PublishSubject<Void> = PublishSubject()
    
    // MARK: - Data
    public let dataSource: Variable<Model.Issue> =  Variable(Model.Issue.empty)
    
    init(_ config: Router.IssueConfig) {
        super.init()
        
        //혹시 다른 이슈 디테일을 사용하는 컨트롤러가 있다면! Model.Issue Detail 업데이트
        _ = IssueService
            .update
            .filter { [unowned self] (hashValue: Int, model: Model.Issue) -> Bool in
                //이미 자신은 업데이트 된거라 또 적용해줄 필요가 없다!
                  self.hashValue != hashValue && self.dataSource.value == model
            }.map { (_, model: Model.Issue) -> Model.Issue in model }
            .takeUntil(rx.deallocated)
            .bindTo(dataSource)
        
        
        _ = refresh
            .flatMap { _ -> Observable<Model.Issue> in
                Router.issue(config: config).dataRequest.rx.responseObject()
            }.takeUntil(rx.deallocated)
            .do(onNext: { [unowned self] (issue: Model.Issue) in
                IssueService.update.onNext((hashValue: self.hashValue, model: issue))
            }).subscribe(onNext: { [unowned self] (value: Model.Issue) in
                self.dataSource.value = value
            })
    }
 
}


