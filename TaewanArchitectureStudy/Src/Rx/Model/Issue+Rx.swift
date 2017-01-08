//
//  Issue+Rx.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 6..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import RxSwift

///맙소사... 이런식의 개발은 Compile Sources 순서가 굉장히 중요하네...


// MARK: - .rx 사용 가능하게 하려면 ReactiveCompatible 요 protocol 필요함.
extension Router.Repository: ReactiveCompatible { }
extension Model.Issue: ReactiveCompatible, RequestRepository { }

extension Reactive where Base: RequestRepository {
    static func list(user: String, repo: String, page: Int? = nil) -> Observable<[Model.Issue]>{
        return Router.Repository
            .issues(user: user, repo: repo, page: page)
            .rx.requestCollection()
            .single()
    }
    
    static func show(user: String, repo: String, number: Int) -> Observable<Model.Issue> {
        return Router.Repository
            .issue(user: user, repo: repo, number: number)
            .rx.requestObject()
            .single()
    }
}



