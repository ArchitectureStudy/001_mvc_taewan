//
//  IssueDetailViewController.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 16..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import UIKit

class IssueDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!

    @IBOutlet weak var collectionView: HDCollectionView!
    
    var model: Model.IssueModel!
    var 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alwaysBounceVertical = true
    }
    
}


// MARK: - Setup
extension IssueDetailViewController {
    func setup() {
        model = Model.IssueModel(user: "JakeWharton", repo: "DiskLruCache", number: 1)
    }
}
