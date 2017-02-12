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

class IssueListViewController: UIViewController, Configurable {
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    let refreshControl = UIRefreshControl()
    
    var viewModel: IssueListViewModel?
    var presenter: IssueListPresenter?
    
    var repositoryConfig: Router.RepositoryConfig? {
        didSet {
            presenter = IssueListPresenter(config: repositoryConfig)
            presenter?.delegate = self
        }
    }
    
    func configure(_ viewModel: IssueListViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        eventSetup()
        refresh(sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.destination {
        case let controller as IssueDetailViewController:
            guard let issue = sender as? DataObject.Issue else {
                assertionFailure("issue data is null")
                return
            }
            controller.title = "#\(issue.number)"
            controller.config = Router.IssueConfig(repository: repositoryConfig, number: issue.number)
        default: break
        }
        
    }
    
    @IBAction func didTapCreateIssue(_ sender: Any) {
        guard let alertController = self.viewModel?.newIssueDidTap() else {
            return
        }
        present(alertController, animated: true, completion: nil)
    }
    
}


// MARK: - Setup
extension IssueListViewController {
    
    func setup() {
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            print("estimatedItemSize")
            flowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 56)
        }
    }
    
    func eventSetup() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    func refresh(sender: Any) {
        print("refresh:\(sender)")
        presenter?.refresh()
    }
}


// MARK: - PresenterDelegate
extension IssueListViewController: IssueListPresenterDelegate {
    func issueListDidLoaded() {
        print("issueListDidLoaded")
        IssueCell.estimatedSizeReset()
        
        refreshControl.endRefreshing()
        collectionView.reloadData()
    }
}

extension IssueListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.model.datas.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueCell", for: indexPath)
        
        if let issueCell = cell as? IssueCell,
            let data = presenter?.model.datas[safe: indexPath.row] {
            issueCell.configure(IssueCellViewModel(data))
            print("indexPath:\(indexPath)")
        }
        print("indexPath-2:\(indexPath)")
        return cell
    }
    
}

extension IssueListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Show", sender:  presenter?.model.datas[safe: indexPath.row])
    }
    
}
