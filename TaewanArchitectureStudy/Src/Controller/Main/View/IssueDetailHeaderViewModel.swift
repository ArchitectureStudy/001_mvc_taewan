//
//  IssueDetailHeaderViewModel.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 3. 4..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation


protocol IssueDetailHeaderViewModelType: ViewModelType {
    var isOpened: Bool { get }
    var title: String { get }
    var info: String { get }
    
    var avatarURL: URL? { get }
    var comment: String { get }
    var commentInfo: String { get }
    
}

struct IssueDetailHeaderViewModel: IssueDetailHeaderViewModelType {
    //output
    let isOpened: Bool
    let title: String
    let info: String
    
    let avatarURL: URL?
    
    let comment: String
    let commentInfo: String
    
    
    init?(_ data: Model.Issue?) {
        guard let data = data, data.id != 0 else { return nil }
        
        let createdAt = data.createdAt?.string(dateFormat: "DD MMM yyyy") ?? "-"
        self.isOpened = data.state == .open
        self.title = data.title
        self.info = "\(data.user.login) \(data.state.display) this issue on \(createdAt) · \(data.comments) comments"
        self.avatarURL = data.user.avatarURL
        self.comment = data.body
        self.commentInfo = "\(data.user.login) commented on \(createdAt)"
    }
}
