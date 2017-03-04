//
//  IssueCellViewModel.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 2. 11..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation


struct IssueCellViewModel: ViewModelType {
    //input
    //??
    
    //output
    let title: String
    let subLabel: String
    let isOpened: Bool
    let isCommentHidden: Bool
    let comments: String
    
    init?(_ data: Model.Issue?) {
        guard let data = data else { return nil }
        
        let createdAt = data.createdAt?.string(dateFormat: "DD MMM yyyy") ?? "-"
        
        title = data.title
        subLabel = "#\(data.number) \(data.state.display) on \(createdAt) by \(data.user.login)"
        isOpened = data.state == .open
        isCommentHidden = data.comments == 0
        comments = "\(data.comments)"
    }

}
