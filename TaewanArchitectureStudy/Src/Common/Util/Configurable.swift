//
//  Configurable.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 2. 11..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation

protocol Configurable {
    associatedtype ViewModelType
    
    func configure(_ viewModel: ViewModelType)
}
