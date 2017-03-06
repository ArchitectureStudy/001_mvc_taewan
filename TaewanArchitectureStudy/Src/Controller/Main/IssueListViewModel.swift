//
//  IssueListViewModel.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 2. 11..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources



typealias IssueListSection = SectionModel<Void, IssueCellModelType>

protocol IssueListViewModelType: class, ViewModelType {
    
    // Input
    var beginRefresh: PublishSubject<Void> { get }
    var loadMore: PublishSubject<Void> { get }
    var itemDidSelect: PublishSubject<IndexPath> { get }
    
    // Ouput
    var sections: Driver<[IssueListSection]> { get }
    var endRefresh: Observable<Void> { get }
    var presentToIsseuDetail: Observable<IssueDetailViewModelType> { get }
}


class IssueListViewModel: NSObject, IssueListViewModelType {
    // MARK: - Service
    let service: IssueListService
    
    // MARK: - Input
    public let beginRefresh: PublishSubject<Void> = PublishSubject<Void>()
    public let loadMore: PublishSubject<Void> = PublishSubject<Void>()
    public let itemDidSelect: PublishSubject<IndexPath> = PublishSubject<IndexPath>()
    
    // MARK: - Output
    public let sections: Driver<[IssueListSection]>
    public let endRefresh: Observable<Void>
    public let presentToIsseuDetail: Observable<IssueDetailViewModelType>
    
    init(config: Router.RepositoryConfig) {
        service = IssueListService(config)
        sections = service.dataSource
            .asObservable()
            .map { (value: [Model.Issue]) -> IssueListSection in
                IssueListSection(model: Void(), items: value.flatMap { IssueCellModel($0) })
            }.map { section -> [IssueListSection] in
                [section]
            }.asDriver(onErrorJustReturn: [])
        
        endRefresh = sections.asObservable().map { _ in }
        
        presentToIsseuDetail = itemDidSelect
            .withLatestFrom(sections) { (indexPath: IndexPath, sections: [IssueListSection]) -> IssueModelType in
                sections[indexPath.section].items[indexPath.row] as IssueModelType
            }.map { (issue: IssueModelType) -> Router.IssueConfig? in
                Router.IssueConfig(repository: config, number: issue.number)
            }.filter { $0 != nil }
            .map { (config: Router.IssueConfig?) -> IssueDetailViewModelType in
                IssueDetailViewModel(config: config!)
            }.asObservable()
        // } 이거 밀려서... asObservable 해줌...ㅋㅋ
        
        super.init()
        
        _ = beginRefresh
            .takeUntil(rx.deallocated)
            .bindTo(service.refresh)
        
        _ = loadMore
            .takeUntil(rx.deallocated)
            .bindTo(service.loadMore)
        
    }
    
    
    
    
}

