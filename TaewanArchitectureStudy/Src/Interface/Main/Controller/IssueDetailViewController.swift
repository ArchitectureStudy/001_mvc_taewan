//
//  IssueDetailViewController.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 16..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import UIKit
import AlamofireImage


class IssueDetailViewController: UIViewController {
    
    
    @IBOutlet var headerView: IssueDetailHeaderView!
    @IBOutlet weak var collectionView: HDCollectionView!
    
    fileprivate var estimateCell: IssueCommentCell = IssueCommentCell()
    fileprivate var estimatedSizes: [IndexPath: CGSize] = [:]
    
    var presenter: IssueDetailPresenter?
    
    var config: Model.IssueConfig? {
        didSet {
            presenter = IssueDetailPresenter(config: config)
            presenter?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.refresh()
        
    }
    
    
}

extension IssueDetailViewController: IssueDetailPresenterDelegate {
    
    func issueDidLoaded() {
        if let data = presenter?.model.data {
            headerView.update(data: data)
//            collectionView.up
        }
        
        collectionView.reloadData()
        
        if collectionView.alpha == 0 {
            UIView.animate(withDuration: 0.4) {
                self.collectionView.alpha = 1
            }
        }
    }
}


// MARK: - Setup
extension IssueDetailViewController  {
    
    func setup() {
        collectionView.headerView = self.headerView
        collectionView.alwaysBounceVertical = true
        collectionView.alpha = 0
      
        
    }
}


extension IssueDetailViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath)
        
        guard let comment = presenter?.model.comments.datas[safe: indexPath.row] else {
            return cell
        }
        
        if let commentCell = cell as? IssueCommentCell {
            commentCell.update(data: comment, withImage: true)
        }
        
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.model.comments.datas.count ?? 0
    }
}


extension IssueDetailViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 8*2
        let targetSize = CGSize(width: width, height: 48)
        
        var estimatedSize = estimatedSizes[indexPath] ?? CGSize.zero
        if estimatedSize != .zero {
            return estimatedSize
        }
        
        if let data = presenter?.model.comments.datas[safe: indexPath.row] {
            estimateCell.update(data: data, withImage: false)
        }
        
        estimatedSize = estimateCell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        estimatedSizes[indexPath] = estimatedSize
        
        return estimatedSize
    }

}
