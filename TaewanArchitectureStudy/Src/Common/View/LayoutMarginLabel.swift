//
//  LayoutMarginLabel.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 1. 21..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import UIKit


/// LayoutMargin을 이용해서 label의 margin을 주면 깔끔하겠다 싶어서 만들었다.
// 인터페이스 빌더에서 디지네... 흑
@IBDesignable
class LayoutMarginLabel: UILabel {
    
    @IBInspectable
    var margins: CGRect = .zero {
        didSet {
            layoutMargins = UIEdgeInsets(top: margins.origin.y, left: margins.origin.x, bottom: margins.size.height, right: margins.size.width)
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize

            size.width  += layoutMargins.left + layoutMargins.right
            size.height += layoutMargins.top + layoutMargins.bottom

        return size
    }
    
//    #if !TARGET_INTERFACE_BUILDER
    override func drawText(in rect: CGRect) {
        let insets = layoutMargins
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
//    #endif
}
