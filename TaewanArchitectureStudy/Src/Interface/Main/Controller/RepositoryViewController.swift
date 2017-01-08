//
//  ViewController.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 6..
//  Copyright © 2017년 taewankim. All rights reserved.
//
import Foundation
import UIKit
import RxSwift

class RepositoryViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var issues: [Model.Issue] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    fileprivate var estimateCell: RepositoryIssueCell!
    fileprivate var estimatedSizes: [IndexPath: CGSize] = [:]
    
    
    let disposeBag = DisposeBag()
    
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
            .rx.list(user: "JakeWharton", repo: "DiskLruCache")
            .subscribe(onNext: { [unowned self] issues in
                self.estimatedSizes = [:]
                self.issues = issues
            }).addDisposableTo(disposeBag)
    }
}


extension RepositoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return issues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueCell", for: indexPath)
        
        guard let model = self.issues[safe: indexPath.row] else { return cell
        }
        if let issueCell = cell as? RepositoryIssueCell {
            issueCell.state = model.state
            issueCell.title = model.title
            issueCell.sub = "#\(model.number) \(model.state.display) on \(model.createdAt?.description ?? "--") by \(model.user.login)"
            //MMM
//            print(model.createdAt)
            //#54 opened on 8 Feb 2014 by Wavesonics
        }
        
        return cell
    }
    
}

extension RepositoryViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let targetSize = CGSize(width: width, height: 48)
        
        guard let model = self.issues[safe: indexPath.row] else {
            return targetSize
        }
        
        var estimatedSize = estimatedSizes[indexPath] ?? CGSize.zero
        if estimatedSize != .zero {
            return estimatedSize
        }
        
        
        estimateCell.title = model.title
        estimateCell.sub = "#\(model.number) \(model.state.display) on \(model.createdAt?.description ?? "--") by \(model.user.login)"//여기서 중복이 일어나네..
        
        estimatedSize = estimateCell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        estimatedSizes[indexPath] = estimatedSize

        return estimatedSize
    }
    
}
