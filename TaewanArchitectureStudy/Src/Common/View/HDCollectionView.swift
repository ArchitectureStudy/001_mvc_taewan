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
    
    @IBOutlet public weak var headerView: UIView? {
        didSet {
            if let oldView = oldValue {  oldView.removeFromSuperview() }
            addHeaderView()
        }
    }
    @IBOutlet public weak var footerView: UIView? {
        didSet {
            if let oldView = oldValue { oldView.removeFromSuperview() }
            addFooterView()
        }
    }
    
    @IBInspectable public var offsetHeader: CGFloat = 0 {
        didSet {  updateOffsetHeader() }
    }
    
    @IBInspectable public var offsetFooter: CGFloat = 0 {
        didSet { updateOffsetFooter() }
    }
    
    @IBInspectable public var fixedHeader: Bool = false
}


extension HDCollectionView {
    public func updateOffsetHeader() {
        if let headerView = self.headerView {
            let size = headerViewSize
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            
            switch scrollDirection {
            case .vertical:
                headerView.frame.size.height = size.height
                contentInset.top = offsetHeader + size.height
                headerView.frame.origin.y = -contentInset.top
            case .horizontal:
                headerView.frame.size.width = size.width
                contentInset.left = offsetHeader + size.width
                headerView.frame.origin.x = -contentInset.left
            }
        } else {
            switch scrollDirection {
            case .vertical:
                contentInset.top = offsetHeader
            case .horizontal:
                contentInset.left = offsetHeader
            }
        }
    }
    
    public func updateOffsetFooter() {
        if let footerView = self.footerView {
            let size = footerViewSize
            footerView.setNeedsLayout()
            footerView.layoutIfNeeded()
            footerView.frame.size.height = size.height
            footerView.frame.origin.y = contentSize.height
            
            contentInset.bottom = offsetFooter + size.height
        } else {
            contentInset.bottom = offsetFooter
        }
    }
    
}


private extension HDCollectionView {
    func addHeaderView() {
        if let headerView = self.headerView, headerView.superview == nil {
            
            switch scrollDirection {
            case .horizontal:
                headerView.frame.size.height = bounds.height
                headerView.autoresizingMask = [.flexibleHeight]
            case .vertical:
                headerView.frame.size.width = bounds.width
                headerView.autoresizingMask = [.flexibleWidth]
            }
            
            addSubview(headerView)
            updateOffsetHeader()
            
            switch scrollDirection {
            case .horizontal:
                contentOffset.x = -contentInset.left
            case .vertical:
                contentOffset.y = -contentInset.top
            }
        }
    }
    
    func addFooterView() {
        if let footerView = self.footerView, footerView.superview == nil {
            switch scrollDirection {
            case .horizontal:
                footerView.frame.size.height = bounds.height
                footerView.autoresizingMask = [.flexibleHeight]
            case .vertical:
                footerView.frame.size.width = bounds.width
                footerView.autoresizingMask = [.flexibleWidth]
            }
            addSubview(footerView)
            updateOffsetFooter()
        }
    }
    
    
    func getHeaderViewFitSize() -> CGSize {
        return extimateSize(view: self.headerView)
    }
    
    func getFooterViewFitSize() -> CGSize {
        return extimateSize(view: self.footerView)
    }
    
    private func extimateSize(view: UIView?) -> CGSize {
        guard let targetView = view else {
            return CGSize.zero
        }
        
        let targetSize: CGSize
        switch scrollDirection {
        case .horizontal:
            targetSize  = CGSize(width: 0, height: bounds.height)
        case .vertical:
            targetSize  = CGSize(width: bounds.width, height: 0)
        }
        
        
        let size = targetView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: UILayoutPriorityRequired,
            verticalFittingPriority: UILayoutPriorityDefaultLow
        )
        
        //        targetView.sizeToFit()
        
        let width = size.width == 0 ? targetView.bounds.width : size.width
        let height = size.height == 0 ? targetView.bounds.height : size.height
        return CGSize(width: width, height: height)
        
    }
}




// MARK: - Getter attribute
extension HDCollectionView {
    fileprivate var scrollDirection: UICollectionViewScrollDirection {
        guard let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout else {
            assertionFailure("support only UICollectionViewFlowLayout")
            return .vertical
        }
        return flowLayout.scrollDirection
    }
    
    public var headerViewSize: CGSize {
        return getHeaderViewFitSize()
    }
    public var footerViewSize: CGSize {
        return getFooterViewFitSize()
    }
    
    public var headerOffset: CGPoint {
        return CGPoint(x: contentOffset.x + contentInset.left, y: contentOffset.y + contentInset.top)
    }
}

// MARK: - override
extension HDCollectionView {
    open override var contentInset: UIEdgeInsets {
        didSet {
            if oldValue == contentInset || fixedHeader == false { return }
            guard let headerView = self.headerView, headerView.superview == self else { return }
            
            headerView.transform = CGAffineTransform.identity
            
            switch scrollDirection {
            case .horizontal:
                headerView.frame.origin.x = -contentInset.left
                let tx = min(0, contentOffset.x + contentInset.left)
                if tx <= 0 {
                    headerView.transform = CGAffineTransform(translationX: tx, y: 0)
                }
            case .vertical:
                headerView.frame.origin.y = -contentInset.top
                let ty = min(0, contentOffset.y + contentInset.top)
                if ty <= 0 {
                    headerView.transform = CGAffineTransform(translationX: 0, y: ty)
                }
            }
            
        }
    }
    
    open override var contentOffset: CGPoint {
        didSet {
            if oldValue == contentOffset || fixedHeader == false { return }
            guard let headerView = self.headerView, headerView.superview == self else { return }
            
            
            switch scrollDirection {
            case .horizontal:
                let tx = min(0, contentOffset.x + contentInset.left)
                if tx <= 0  && (contentInset.left/2) <= (contentOffset.x * -1) {
                    headerView.transform = CGAffineTransform(translationX: tx, y: 0)
                }
            case .vertical:
                let ty = min(0, contentOffset.y + contentInset.top)
                if ty <= 0  && (contentInset.top/2) <= (contentOffset.y * -1) {
                    headerView.transform = CGAffineTransform(translationX: 0, y: ty)
                }
            }
            
            
            
        }
    }
    
    open override var contentSize: CGSize {
        didSet {
            updateOffsetFooter()
        }
    }
    
}
