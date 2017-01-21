//
//  API.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 6..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON



/// Model
public struct DataObject {
    /// API/DataObject/* 폴더에 만들어서 사용한다.
}

public struct Model {
    /// API/Model/* 폴더에 만들어서 사용한다.
}



/// DTO 넣어주는것
public protocol DataObjectUpdatable {
    associatedtype DataObjectItemType
    
    func update(data: DataObjectItemType, withImage: Bool)
}


extension DataObjectUpdatable {
    func update(data: DataObjectItemType, withImage: Bool = false) {}
}
