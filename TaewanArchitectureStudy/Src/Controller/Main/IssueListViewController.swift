//
//  ViewController.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 6..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class IssueListViewController: RxViewController, Configurable {
    
    @IBOutlet var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    
    private var viewModel: IssueListViewModel!
    private var router: IssueListViewRouterInput!
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<IssueListSection>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        rxSetup()
    }
    
    func configure(_ viewModel: IssueListViewModel) {
        self.viewModel = viewModel
    }
    
    private func setup() {
        router = IssueListViewRouter(self)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 56)
        }
        
        dataSource.configureCell = { _, collectionView, indexPath, viewModel in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueCell", for: indexPath)
            (cell as? AnyConfigurable)?.configure(viewModel)
            return cell
        }
    }
    
    private func rxSetup() {
        assert(viewModel != nil, "viewModel이 nil이라니!! 신경좀 씁시다!!")
        
        /// Input
        refreshControl
            .rx.controlEvent(.valueChanged)
            .bindTo(viewModel.beginRefresh)
            .disposed(by: disposeBag)
        
        collectionView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView
            .rx.itemSelected
            .bindTo(viewModel.itemDidSelect)
            .disposed(by: disposeBag)
        
        /// Output
        viewModel.sections
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.endRefresh
            .subscribe(onNext: { [unowned self] _ in
                self.refreshControl.endRefreshing()
            }).disposed(by: disposeBag)
        
        viewModel.presentToIsseuDetail
            .subscribe(onNext: { [unowned self] (viewModel: IssueDetailViewModelType) in
                self.router.navigateToIssueDetail(viewModel)
            }).disposed(by: disposeBag)
        
        //first load
        viewModel.beginRefresh.onNext(Void())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        assert(router != nil, "router이 nil이라니!! 신경좀 씁시다!!")
        router.passDataToNextScene(segue: segue, sender: sender)
    }
    
}

extension IssueListViewController: UICollectionViewDelegate { }
