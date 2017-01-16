//
//  Issue.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 6..
//  Copyright © 2017년 taewankim. All rights reserved.
//
import UIKit
import Foundation
import SwiftyJSON


extension DTO {
    public struct Issue: ResponseCollectionSerializable, ResponseObjectSerializable {
        let id: Int
        let number: Int
        let title: String
        let user: DTO.User
        let state: State
        let comments: Int
        let body: String
        let createdAt: Date?
        let updatedAt: Date?
        let closedAt: Date?
        
        public init(json: JSON) {
            id = json["id"].intValue
            number = json["number"].intValue
            title = json["title"].stringValue
            user = DTO.User(json: json["user"])
            state = State(rawValue: json["state"].stringValue) ?? .none
            comments = json["comments"].intValue
            body = json["body"].stringValue
            
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            createdAt = format.date(from: json["created_at"].stringValue)
            updatedAt = format.date(from: json["updated_at"].stringValue)
            closedAt = format.date(from: json["closed_at"].stringValue)
        }
    }
}

extension DTO.Issue {
    enum State: String {
        case open = "open", close = "close", none = "none"
        
        var display: String {
            switch self {
            case .open: return "opened"
            case .close: return "closed"
            default: return "-"
            }
        }
    }
}
