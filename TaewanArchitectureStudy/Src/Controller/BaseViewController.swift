//
//  BaseViewController.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 3. 4..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import UIKit

open class BaseViewController: UIViewController {
    
    deinit {
        let name = type(of: self).description().components(separatedBy: ".").last!
        print("**** deinit - \(name) ****")

    }
}
