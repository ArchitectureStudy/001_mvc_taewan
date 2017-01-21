//
//  Comment.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 1. 16..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import SwiftyJSON


extension DataObject {
    public struct Comment: ResponseCollectionSerializable, ResponseObjectSerializable {
        
        let id: Int
        let user: DataObject.User
        
        let body: String
        let createdAt: Date?
        let updatedAt: Date?
        
        public init(json: JSON) {
            id = json["id"].intValue
            user = DataObject.User(json: json["user"])
            body = json["body"].stringValue
            
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            createdAt = format.date(from: json["created_at"].stringValue)
            updatedAt = format.date(from: json["updated_at"].stringValue)
        }
        
    }
}
