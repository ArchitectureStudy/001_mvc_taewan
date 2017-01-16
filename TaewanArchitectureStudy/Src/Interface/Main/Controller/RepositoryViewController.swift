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

class RepositoryViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var model: Model.IssuesModel!
    
    fileprivate var estimateCell: RepositoryIssueCell!
    fileprivate var estimatedSizes: [IndexPath: CGSize] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        refresh()
    }
}


// MARK: - Setup
extension RepositoryViewController {
    func setup() {
        model = Model.IssuesModel(user: "JakeWharton", repo: "DiskLruCache")
        estimateCell = RepositoryIssueCell()
    }
}


// MARK: - Network
extension RepositoryViewController {
    
    func refresh() {
        model.refresh().response { _ in
            self.collectionView.reloadData()
        }
    }
}


extension RepositoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueCell", for: indexPath)
        
        guard let model = model.list[safe: indexPath.row] else {
            return cell
        }
        
        if let issueCell = cell as? RepositoryIssueCell {
            issueCell.state = model.state
            issueCell.title = model.title
            issueCell.sub = cellSubString(model)
        }
        return cell
    }
    
}

extension RepositoryViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let targetSize = CGSize(width: collectionView.bounds.width, height: 48)
        
        var estimatedSize = estimatedSizes[indexPath] ?? CGSize.zero
        if estimatedSize != .zero {
            return estimatedSize
        }
        
        if let model = model.list[safe: indexPath.row] {
            estimateCell.title = model.title
            estimateCell.sub = cellSubString(model)
        }
        
        estimatedSize = estimateCell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        estimatedSizes[indexPath] = estimatedSize
        
        return estimatedSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Show", sender:  model.list[safe: indexPath.row])
    }
    
}



// MARK: - Helper
extension RepositoryViewController {
    func cellSubString(_ model: DTO.Issue) -> String {
        return "#\(model.number) \(model.state.display) on \(model.createdAt?.description ?? "--") by \(model.user.login)"
    }
}
