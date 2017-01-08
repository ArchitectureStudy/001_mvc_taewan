//
//  ViewController.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 6..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
//        Router.Repository.issues(user: "", repo: "").rx.list()
        
        Model.Issue
            .rx.list(user: "asdas", repo: "asd")
            .subscribe(onNext: { issues in
         
        })

    }


}


