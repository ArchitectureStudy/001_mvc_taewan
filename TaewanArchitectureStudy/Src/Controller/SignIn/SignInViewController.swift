//
//  SignInViewController.swift
//  TaewanArchitectureStudy
//
//  Created by taewan on 2017. 1. 23..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var signInBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var repositoryTextField: UITextField!
    @IBOutlet weak var tokenTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        eventSetup()
    }
    
    @IBAction func dismissKeyboardRecognizer(_ sender: Any) {
        self.view.endEditing(true)
    }
    

    
}

// MARK: - Setup
extension SignInViewController {
    
    func setup() {
        tokenTextField.text = Router.accessToken
    }
    
    func eventSetup() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(onChangedKeyboard), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
}


// MARK: - Notification selectors
extension SignInViewController {
    
    func onChangedKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardInfo = KeyboardInfo(userInfo) else {
                return
        }
        let hidden = keyboardInfo.endFrame.origin.y >= UIScreen.main.bounds.size.height
        UIView.animate(withDuration: keyboardInfo.duration, delay: 0, options: keyboardInfo.animationOptions, animations: {
            self.signInBottomConstraint.constant = hidden ? 0 : (keyboardInfo.endFrame.size.height + 32)
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
}


// MARK: - override
extension SignInViewController {
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let user = self.userField.text,
            let repo = self.repositoryTextField.text,
            let token = self.tokenTextField.text else {
            return false
        }
        
        if user.isEmpty || repo.isEmpty || token.isEmpty {
            return false
        }
        Router.accessToken = token
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch targetController(segue.destination) {
        case let controller as IssueListViewController:
            controller.config = Router.RepositoryConfig(user: self.userField.text, repo: self.repositoryTextField.text)
        default: break
        }
    }
    
    func targetController(_ viewController: UIViewController) -> UIViewController {
        if viewController is UINavigationController {
            return viewController.childViewControllers.first ?? viewController
        }
        return viewController
    }
}
