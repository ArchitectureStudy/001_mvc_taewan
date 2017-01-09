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
    
    var issues: [Model.Issue] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
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
        estimateCell = RepositoryIssueCell()
    }
}


// MARK: - Network
extension RepositoryViewController {
    
    func refresh() {
        Model.Issue
            .list(user: "JakeWharton", repo: "DiskLruCache") { result in
                switch result {
                case .failure(_):
                    print("----- error -----")
                case .success(let value):
                    self.estimatedSizes = [:]
                    self.issues = value
                }
        }
    }
}


extension RepositoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return issues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueCell", for: indexPath)
        
        guard let model = self.issues[safe: indexPath.row] else {
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
        
        if let model = self.issues[safe: indexPath.row] {
            estimateCell.title = model.title
            estimateCell.sub = cellSubString(model)
        }
        
        estimatedSize = estimateCell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        estimatedSizes[indexPath] = estimatedSize
        
        return estimatedSize
    }
    
}



// MARK: - Helper
extension RepositoryViewController {
    func cellSubString(_ model: Model.Issue) -> String {
        return "#\(model.number) \(model.state.display) on \(model.createdAt?.description ?? "--") by \(model.user.login)"
    }
}
