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
    
    fileprivate var estimateCell: IssueCell = IssueCell()
    fileprivate var estimatedSizes: [IndexPath: CGSize] = [:]
    
    var presenter: IssueListPresenter?
    
    var config: Model.RepositoryConfig? {
        didSet {
            presenter = IssueListPresenter(config: config)
            presenter?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        config = Model.RepositoryConfig(user: "ArchitectureStudy", repo: "study")
        presenter?.refresh()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.destination {
        case let controller as IssueDetailViewController:
            guard let issue = sender as? DataObject.Issue else {
                assertionFailure("issue data is null")
                return
            }
            controller.title = "#\(issue.number)"
            controller.config = Model.IssueConfig(repository: config, number: issue.number)
            
        default: break
        }
        
    }
}


// MARK: - Setup
extension IssueListViewController {
 
    func setup() {
        
    }
}


// MARK: - Network
extension IssueListViewController: IssueListPresenterDelegate {
    func issueListDidLoaded() {
        collectionView.reloadData()
    }
}


extension IssueListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.model.datas.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueCell", for: indexPath)
        
        guard let data = presenter?.model.datas[safe: indexPath.row] else {
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
        
        if let data = presenter?.model.datas[safe: indexPath.row] {
            estimateCell.update(data: data)
        }
        
        estimatedSize = estimateCell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        estimatedSizes[indexPath] = estimatedSize
        
        return estimatedSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Show", sender:  presenter?.model.datas[safe: indexPath.row])
    }
    
}
