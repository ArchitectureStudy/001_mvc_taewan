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
    // static
    static var updateItem: PublishSubject<Model.Issue> { get }
    static var refresh: PublishSubject<Router.RepositoryConfig> { get }
    
    // Property
    var page: Int { get }
    
    // Input
    var refresh: PublishSubject<Void> { get }
    var loadMore: PublishSubject<Void> { get }
    
    // Data
    var dataSource: Variable<[Model.Issue]> { get }
}



public class IssueListService: NSObject, IssueListServiceType {
    // MARK: - Static
    
    //음 내용교체할때는 문제가 안되는데.. 새로운거 추가하는 경우는?
    public static let updateItem: PublishSubject<Model.Issue> = PublishSubject()
    public static let refresh: PublishSubject<Router.RepositoryConfig> = PublishSubject()
    
    
    // MARK: - Property
    public private(set) var page: Int = 1
    
    // MARK: - Input
    public let refresh: PublishSubject<Void> = PublishSubject()
    public let loadMore: PublishSubject<Void> = PublishSubject()
    
    // MARK: - Data
    public let dataSource: Variable<[Model.Issue]> = Variable([])
    
    init(_ config: Router.RepositoryConfig) {
        super.init()

        _ = IssueListService
            .refresh
            .takeUntil(rx.deallocated)//바꾸기 원하는거랑 같은 config라면!!
            .filter { (targetConfig: Router.RepositoryConfig) -> Bool in
                config == targetConfig
            }.map { _ in }//같은 config 라도 전부 새로고침하면 좀 버벅거리지 않을까? 아 몰랑!
            .bindTo(refresh)
        
        //일치하는 Model.Issue item 업데이트
        _ = IssueListService
            .updateItem
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { [unowned self] issue in
                guard let index = self.dataSource.value.index(of: issue) else { return }
                self.dataSource.value[index] = issue
            })
        
        
        
        
        _ = refresh
            .do(onNext: { [unowned self] _ in
                self.page = 1
            }).flatMap { _ -> Observable<[Model.Issue]> in
                Router.issues(config: config, page: nil).dataRequest.rx.responseCollection()
            }.takeUntil(rx.deallocated)
            .subscribe(onNext: { [unowned self] (value: [Model.Issue]) in
                self.dataSource.value = value
            })
        
        _ = loadMore
            .map { [unowned self] in
                self.page += 1
                return self.page
            }.flatMap { page -> Observable<[Model.Issue]> in
                Router.issues(config: config, page: page).dataRequest.rx.responseCollection()
            }.takeUntil(rx.deallocated)
            .subscribe(onNext: { [unowned self] (value: [Model.Issue]) in
                self.dataSource.value += value
            })
        
    }
    
}
