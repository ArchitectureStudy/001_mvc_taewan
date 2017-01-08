//
//  Collection+Extension.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 1. 8..
//  Copyright © 2017년 taewankim. All rights reserved.
// http://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings

import Foundation


// MARK: - safe array
extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
