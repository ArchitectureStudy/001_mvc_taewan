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

extension Router.Repository: ReactiveCompatible { }
extension Model.Issue: ReactiveCompatible, RequestRepository { }

extension Reactive where Base: RequestRepository {
    static func list(user: String, repo: String) -> Observable<[Model.Issue]>{
        return Router.Repository.issues(user: user, repo: repo).rx.requestCollection()
    }
}
