//
//  IssueDetailViewModel.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 3. 4..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources


typealias CommentListSection = SectionModel<Void, IssueCommentCellModelType>

protocol IssueDetailViewModelType: class, ViewModelType {
    
    // Input
    var beginRefresh: PublishSubject<Void> { get }
    var loadMore: PublishSubject<Void> { get }
    
    // Ouput
    var header: Driver<IssueDetailHeaderViewModelType?> { get }
    var commentSections: Driver<[CommentListSection]> { get }
    var endRefresh: Observable<Void> { get }
    
}


class IssueDetailViewModel: NSObject, IssueDetailViewModelType {
    // MARK: Service
    let service: IssueService
    let commentService: CommentListService
    
    // MARK: Input
    let beginRefresh: PublishSubject<Void> = PublishSubject()
    let loadMore: PublishSubject<Void> = PublishSubject()
    
    // MARK: Output
    let header: Driver<IssueDetailHeaderViewModelType?>
    let commentSections: Driver<[CommentListSection]>
    let endRefresh: Observable<Void>
    
    init(config: Router.IssueConfig) {
        service = IssueService(config)
        commentService = CommentListService(config)
        
        header = service.dataSource
            .asObservable()
            .map { (issue: Model.Issue) in
                IssueDetailHeaderViewModel(issue)
            }.asDriver(onErrorJustReturn: nil)
        
       commentSections = commentService.dataSource
            .asObservable()
            .map { (value: [Model.Comment]) -> CommentListSection in
                CommentListSection(model: Void(), items: value.flatMap { IssueCommentCellModel($0) })
            }.map { section -> [CommentListSection] in
                [section]
            }.asDriver(onErrorJustReturn: [])
        
        endRefresh = header.asObservable().map { _ in }
        
        super.init()
        
        //숭아님 shareReplay 좀 설명해주세요
        let refresh = beginRefresh.shareReplay(1)
        
        _ = refresh
            .takeUntil(rx.deallocated)
            .bindTo(service.refresh)
        
        _ = refresh
            .takeUntil(rx.deallocated)
            .bindTo(commentService.refresh)
        
        _ = loadMore
            .takeUntil(rx.deallocated)
            .bindTo(commentService.loadMore)
    }
    
    
    
    
}

