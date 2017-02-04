//
//  Date+Extension.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 9..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation


extension Date {
    func string(dateFormat: String, locale: String = "en-US") -> String {
        let format = DateFormatter()
        format.dateFormat = dateFormat
        format.locale = Locale(identifier: locale)
        return format.string(from: self)
    }
}
