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
        let gravatarId: String
        let type: String
        let siteAdmin: Bool
        
        public init(json: JSON) {
            id = json["id"].intValue
            login = json["login"].stringValue
            avatarURL = json["avatar_url"].stringValue
            gravatarId = json["gravatar_id"].stringValue
            type = json["type"].stringValue
            siteAdmin = json["site_admin"].boolValue
        }
    }
}
