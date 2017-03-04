//
//  IssueCellViewModel.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 2. 11..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation

//흑 이거 남나 고민이네.. 시륭... 이런거 다른 아이디어나
//쓸만한 이름 있음 좋겠다..
protocol IssueModelType {
    var id: Int { get }
    var navigationTitle: String { get }
}

protocol IssueCellModelType: ViewModelType, IssueModelType {
    var title: String { get }
    var subLabel: String { get }
    var isOpened: Bool { get }
    var isCommentHidden: Bool { get }
    var comments: String { get }
}

struct IssueCellModel: IssueCellModelType {
    let id: Int
    let navigationTitle: String
    
    //output
    let title: String
    let subLabel: String
    let isOpened: Bool
    let isCommentHidden: Bool
    let comments: String
    
    init?(_ data: Model.Issue?) {
        guard let data = data else { return nil }
        
        let createdAt = data.createdAt?.string(dateFormat: "DD MMM yyyy") ?? "-"
        
        self.title = data.title
        self.subLabel = "#\(data.number) \(data.state.display) on \(createdAt) by \(data.user.login)"
        self.isOpened = data.state == .open
        self.isCommentHidden = data.comments == 0
        self.comments = "\(data.comments)"
        
        
        self.id = data.id
        self.navigationTitle = "#\(data.number)"
    }

}
