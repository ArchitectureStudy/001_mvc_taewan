//
//  User.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 6..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import SwiftyJSON


extension Model {
    public struct User: ResponseCollectionSerializable, ResponseObjectSerializable {
        let id: Int
        let login: String
        let avatarURL: String
        
        public init(json: JSON) {
            id = json["id"].intValue
            login = json["login"].stringValue
            avatarURL = json["avatar_url"].stringValue
        }
        
        public init(login: String) {
            self.id = 0
            self.login = login
            self.avatarURL = ""
        }
    }
}


extension Model.User {
    var isFakeModel: Bool {
        return id == 0
    }
}
