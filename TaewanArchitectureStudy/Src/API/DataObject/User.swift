//
//  User.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 6..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import SwiftyJSON


extension DataObject {
    public struct User: ResponseCollectionSerializable, ResponseObjectSerializable {
        let id: Int
        let login: String
        let avatarURL: URL?
        
        public init(json: JSON) {
            id = json["id"].intValue
            login = json["login"].stringValue
            
            avatarURL = URL(string: json["avatar_url"].stringValue)
        }
        
    }
}
