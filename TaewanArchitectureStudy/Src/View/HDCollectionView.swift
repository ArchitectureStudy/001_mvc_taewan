//
//  HDCollectionView.swift
//  HDCommon
//
//  Created by kimtaewan on 2016. 5. 26..
//  Copyright © 2016년 prnd. All rights reserved.
//

import UIKit


@IBDesignable
open class HDCollectionView: UICollectionView {
    
    @IBOutlet open weak var headerView: UIView? {
        didSet {
            if let oldView = oldValue {
                oldView.removeFromSuperview()
            }
            addHeaderView()
        }
    }
    @IBOutlet open weak var footerView: UIView? {
        didSet {
            if let oldView = oldValue {
                oldView.removeFromSuperview()
            }
            addFooterView()
        }
    }
    
    @IBInspectable open var fixedHeader: Bool = false
    
    @IBInspectable open var offsetTop: CGFloat = 0 {
        didSet {
            updateOffsetTop()
        }
    }
    
    @IBInspectable open var offsetBottom: CGFloat = 0 {
        didSet {
            updateOffsetBoottom()
        }
    }
    
    open var headerViewSize: CGSize {
        return getHeaderViewFitSize()
    }
    open var footerViewSize: CGSize {
        return getFooterViewFitSize()
    }
    
    
    private var oldFixed = true
    
    open override var contentInset: UIEdgeInsets {
        didSet {
            if oldValue == contentInset || fixedHeader == false {
                return
            }
            guard let headerView = self.headerView, headerView.superview == self else {
                return
            }
            headerView.transform = CGAffineTransform.identity
            headerView.frame.origin.y = -contentInset.top
            let ty = min(0, contentOffset.y + contentInset.top)
            if ty <= 0 {
                headerView.transform = CGAffineTransform(translationX: 0, y: ty)
            }
        }
    }
    
    open override var contentOffset: CGPoint {
        didSet {
            if oldValue == contentOffset || fixedHeader == false {
                return
            }
            guard let headerView = self.headerView, headerView.superview == self else {
                return
            }
            
            let ty = min(0, contentOffset.y + contentInset.top)
            if ty <= 0  && (contentInset.top/2) <= (contentOffset.y * -1) {
                headerView.transform = CGAffineTransform(translationX: 0, y: ty)
            }
        }
    }
    
    open override var contentSize: CGSize {
        didSet {
            updateOffsetBoottom()
        }
    }
    
    
    //이거가 조금 이상하네..
    open func scrollIndicatorHeader(_ offset: CGFloat = 0) {
        if headerView == nil {
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let me = self else {
                return
            }
            let insets = me.scrollIndicatorInsets
            me.scrollIndicatorInsets.top = insets.top + me.headerViewSize.height + offset
        }
    }
}


extension HDCollectionView {
    //중간에 높이가 다이나믹하게 변경될때는 어떻게 처리 할것인가?
    public func updateOffsetTop() {
        if let headerView = self.headerView {
            let size = headerViewSize
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            headerView.frame.size.height = size.height
            
            contentInset.top = offsetTop + size.height
            headerView.frame.origin.y = -contentInset.top
        } else {
            contentInset.top = offsetTop
        }
    }
    
    public func updateOffsetBoottom() {
        if let footerView = self.footerView {
            let size = footerViewSize
            footerView.setNeedsLayout()
            footerView.layoutIfNeeded()
            footerView.frame.size.height = size.height
            footerView.frame.origin.y = contentSize.height
            
            contentInset.bottom = offsetBottom + size.height
        } else {
            contentInset.bottom = offsetBottom
        }
    }
    
}


private extension HDCollectionView {
    func addHeaderView() {
        if let headerView = self.headerView, headerView.superview == nil {
            let width = bounds.width
            headerView.frame.size.width = width
            headerView.autoresizingMask = [.flexibleWidth]
            
            addSubview(headerView)
            updateOffsetTop()
            contentOffset.y = -contentInset.top
        }
        
    }
    
    func addFooterView() {
        if let footerView = self.footerView, footerView.superview == nil {
            let width = bounds.width
            footerView.frame.size.width = width
            footerView.autoresizingMask = [.flexibleWidth]
            
            addSubview(footerView)
            updateOffsetBoottom()
        }
    }
    
    
    func getHeaderViewFitSize() -> CGSize {
        guard let headerView = self.headerView else {
            return CGSize.zero
        }
        
        let width = bounds.width
        
        let size = headerView.systemLayoutSizeFitting(CGSize(width: width, height: 0), withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        let height = size.height == 0 ? headerView.bounds.height : size.height
        
        return CGSize(width: width, height: height)
    }
    
    
    func getFooterViewFitSize() -> CGSize {
        guard let footerView = self.footerView else {
            return CGSize.zero
        }
        
        let width = bounds.width
        
        let size = footerView.systemLayoutSizeFitting(CGSize(width: width, height: 0), withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        let height = size.height == 0 ? footerView.bounds.height : size.height
        
        return CGSize(width: width, height: height)
    }
    
}
