//
//  ViewController.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 6..
//  Copyright © 2017년 taewankim. All rights reserved.
//
import Foundation
import UIKit
import Alamofire

class IssueListViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var model: Model.IssuesModel!
    
    fileprivate var estimateCell: IssueCell!
    fileprivate var estimatedSizes: [IndexPath: CGSize] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        refresh()
    }
}


// MARK: - Setup
extension IssueListViewController {
    func setup() {
        model = Model.IssuesModel(user: "JakeWharton", repo: "DiskLruCache")
        estimateCell = IssueCell()
    }
}


// MARK: - Network
extension IssueListViewController {
    
    func refresh() {
        model.refresh().response { _ in
            self.collectionView.reloadData()
        }
    }
}


extension IssueListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueCell", for: indexPath)
        
        guard let data = model.list[safe: indexPath.row] else {
            return cell
        }
        
        if let issueCell = cell as? IssueCell {
            issueCell.update(data: data)
        }
        return cell
    }
    
}

extension IssueListViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let targetSize = CGSize(width: collectionView.bounds.width, height: 48)
        
        var estimatedSize = estimatedSizes[indexPath] ?? CGSize.zero
        if estimatedSize != .zero {
            return estimatedSize
        }
        
        if let data = model.list[safe: indexPath.row] {
            estimateCell.update(data: data)
        }
        
        estimatedSize = estimateCell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        estimatedSizes[indexPath] = estimatedSize
        
        return estimatedSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Show", sender:  model.list[safe: indexPath.row])
    }
    
}

