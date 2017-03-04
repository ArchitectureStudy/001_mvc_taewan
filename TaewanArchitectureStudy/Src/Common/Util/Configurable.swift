//
//  Configurable.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 2. 11..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation

public protocol ViewModelType {}


public protocol Configurable: class {
    associatedtype ViewModel = ViewModelType
    func configure(_ viewModel: ViewModel)
}

public protocol AnyConfigurable: class {
    func configure(_ any: Any?)
}

public extension AnyConfigurable where Self: Configurable {
    func configure(_ any: Any?) {
        guard let viewModel = any as? ViewModel else {
            assertionFailure("ViewModelType이 에러인가 보당!")
            return
        }
        configure(viewModel)
    }
}
