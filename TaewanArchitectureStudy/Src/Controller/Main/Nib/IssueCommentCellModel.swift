//
//  IssueCommentCellModel.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 3. 4..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation


protocol IssueCommentCellModelType: ViewModelType {
    var avatarURL: URL? { get }
    var info: String { get }
    var body: String { get }
}

struct IssueCommentCellModel: IssueCommentCellModelType {
    
    //output
    let avatarURL: URL?
    let info: String
    let body: String
    
    init?(_ data: Model.Comment?) {
        guard let data = data else { return nil }
        let createdAt = data.createdAt?.string(dateFormat: "DD MMM yyyy") ?? "-"
        self.avatarURL = data.user.avatarURL
        self.info = "\(data.user.login) commented on \(createdAt)"
        self.body = data.body
    }
}
