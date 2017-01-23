//
//  KeyboardInfo.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 1. 23..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import UIKit


/// https://github.com/ArchitectureStudy/chope/blob/master/ChopeArchitectureStudy/Utils/FoundationExtension.swift
/// 갓촢님 >_< 덕분에 쉽게 개발
struct KeyboardInfo {
    
    let beginFrame: CGRect
    let endFrame: CGRect
    let duration: Double
    let animationOptions: UIViewAnimationOptions
    
    init?(_ userinfo: [AnyHashable : Any]) {
        
        guard let beginFrameValue = userinfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue,
            let endFrameValue = userinfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let durationValue = userinfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
            let animationOptionsValue = userinfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else {
                return nil
        }
        
        self.beginFrame = beginFrameValue.cgRectValue
        self.endFrame = endFrameValue.cgRectValue
        self.duration = durationValue.doubleValue
        self.animationOptions = UIViewAnimationOptions(rawValue: animationOptionsValue.uintValue << 16)
        
    }
}
