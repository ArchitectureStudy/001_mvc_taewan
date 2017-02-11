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
    
    let refreshControl = UIRefreshControl()
    
    var presenter: IssueListPresenter?
    
    var config: Router.RepositoryConfig? {
        didSet {
            presenter = IssueListPresenter(config: config)
            presenter?.delegate = self
        }
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
            controller.config = Router.IssueConfig(repository: config, number: issue.number)
            
        default: break
        }
        
    }
    
    @IBAction func didTapCreateIssue(_ sender: Any) {
        let alert = UIAlertController(title: "는 훼이크", message: "힇 속았지?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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
        IssueCell.eistimatedSizeReset()
        
        refreshControl.endRefreshing()
        collectionView.reloadData()
        
        print("presenter?.model.datas.count:\(presenter?.model.datas.count)")
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
        }
        
        return cell
    }
    
}

extension IssueListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Show", sender:  presenter?.model.datas[safe: indexPath.row])
    }
    
}
