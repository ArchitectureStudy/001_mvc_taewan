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
    
    /// service는 viewModel에서만 관리하면 좋겠는데.. private 로는 못하낭 ㅠㅜ
    var service: IssueListService { get }
    //네트워크 모델도 여기에 있어야하지 않을까?
    
    // MARK: Input
    var beginRefresh: PublishSubject<Void> { get }
    var loadMore: PublishSubject<Void> { get }
    var itemDidSelect: PublishSubject<IndexPath> { get }
    
    // MARK: Ouput
    var sections: Driver<[IssueListSection]> { get }
    var endRefresh: Observable<Void> { get }
    var presentIsseuDetailViewModel: Observable<IssueDetailViewModelType> { get }
}


class IssueListViewModel: NSObject, IssueListViewModelType {
    
    let service: IssueListService
    
    public let beginRefresh: PublishSubject<Void> = PublishSubject<Void>()
    public let loadMore: PublishSubject<Void> = PublishSubject<Void>()
    public let itemDidSelect: PublishSubject<IndexPath> = PublishSubject<IndexPath>()
    
    public let sections: Driver<[IssueListSection]>
    public let endRefresh: Observable<Void>
    public let presentIsseuDetailViewModel: Observable<IssueDetailViewModelType>
    
    init(config: Router.RepositoryConfig) {
        service = IssueListService(config: config)
        sections = service.dataSource
            .asObservable()
            .map { (value: [Model.Issue]) -> IssueListSection in
                IssueListSection(model: Void(), items: value.flatMap { IssueCellModel($0) })
            }.map { section -> [IssueListSection] in
                [section]
            }.asDriver(onErrorJustReturn: [])
        
        endRefresh = sections.asObservable().map { _ in }
        
        presentIsseuDetailViewModel = itemDidSelect
            .withLatestFrom(sections) { (indexPath: IndexPath, sections: [IssueListSection]) -> IssueModelType in
                sections[indexPath.section].items[indexPath.row] as IssueModelType
            }.map { IssueDetailViewModel(config: config, issue: $0) }
        
        
        super.init()
        
        _ = beginRefresh
            .takeUntil(rx.deallocated)
            .bindTo(service.refresh)
        
        _ = loadMore
            .takeUntil(rx.deallocated)
            .bindTo(service.loadMore)
        
    }
    
    
    
    
}

