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
    
    var viewModel: IssueListViewModel?
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel?.refresh(sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    func setup() {
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            print("estimatedItemSize")
            flowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 56)
        }
        
        if let viewModel = self.viewModel {
            refreshControl.addTarget(viewModel,
                                     action: #selector(viewModel.refresh(sender:)),
                                     for: .valueChanged)
        }
    }
    
    func configure(_ viewModel: IssueListViewModel) {
        self.viewModel = viewModel
        viewModel.listDidLoaded = { [weak self] _ in
            //엇 로드 모어일때는 reset 해주면 안되는건데.
            IssueCell.estimatedSizeReset()
            self?.refreshControl.endRefreshing()
            self?.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let controller as IssueDetailViewController:
            guard let issue = sender as? Model.Issue else {
                assertionFailure("issue data is null")
                return
            }
            controller.title = "#\(issue.number)"
            if let repository = viewModel?.config {
                controller.config = Router.IssueConfig(repository: repository, number: issue.number)
            }
        default: break
        }
        
    }
    
    @IBAction func didTapCreateIssue(_ sender: Any) {
        guard let alertController = self.viewModel?.newIssueDidTap() else { return }
        present(alertController, animated: true, completion: nil)
    }
}


extension IssueListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItems ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueCell", for: indexPath)
        
        if let issueCell = cell as? IssueCell,
            let data = viewModel?.service.datas[safe: indexPath.row] {
            issueCell.configure(IssueCellViewModel(data))
        }
        return cell
    }
    
}

extension IssueListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Show", sender: viewModel?.service.datas[safe: indexPath.row])
    }
    
}
