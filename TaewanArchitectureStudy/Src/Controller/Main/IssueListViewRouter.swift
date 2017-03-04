//
//  IssueListViewRouter.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 3. 4..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import UIKit

protocol ViewRouter {
    weak var viewController: UIViewController? { get }
}

protocol ViewRouterInput {
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?)
}

protocol IssueListViewRouterInput: ViewRouterInput {
    func navigateToIssueDetail(_ viewModel: IssueDetailViewModelType)
}

extension UIViewController {
    func performSegue<T : RawRepresentable>(with identifier: T, sender: Any? = nil) where T.RawValue == String {
        self.performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
}

class IssueListViewRouter: ViewRouter, IssueListViewRouterInput {
    enum Identifier: String, RawRepresentable {
        case show = "Show"
    }
    
    weak var viewController: UIViewController?
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    
    // MARK: Navigation
    func navigateToIssueDetail(_ viewModel: IssueDetailViewModelType) {
        viewController?.performSegue(with: Identifier.show, sender: viewModel)
    }
    
    // MARK: Communication
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any? = nil) {
        guard let identifier = Identifier(rawValue: segue.identifier ?? "") else {
            assertionFailure("segue.identifier: \(segue.identifier)가 아주 거지 같은거 같은데!!")
            return
        }
        
        switch identifier {
        case .show:
            passDataToIssueDetail(segue: segue, viewModel: sender as? IssueDetailViewModelType)
        }
    }
    
    
    func passDataToIssueDetail(segue: UIStoryboardSegue, viewModel: IssueDetailViewModelType?) {
        guard let controller = segue.destination as? IssueDetailViewController else {
            assertionFailure("잘못된 segue가 전달 되었구나.")
            return
        }
        print(controller)
        //        controller.title = "#\(issue.number)"
        //        controller.config = config//Router.IssueConfig(repository: config, number: issue.number)
        
    }
}
