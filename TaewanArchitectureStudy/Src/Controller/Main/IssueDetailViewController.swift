//
//  IssueDetailViewController.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 16..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import UIKit
import AlamofireImage

fileprivate extension TimeInterval {
    static let basic: TimeInterval = 0.4
}

class IssueDetailViewController: UIViewController {
    
    @IBOutlet var headerView: IssueDetailHeaderView!
    @IBOutlet weak var collectionView: HDCollectionView!
    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var commentBottomConstraint: NSLayoutConstraint!
    
    fileprivate var estimateCell: IssueCommentCell = IssueCommentCell()
    fileprivate var estimatedSizes: [IndexPath: CGSize] = [:]
    
    let refreshControl = UIRefreshControl()
    
    var presenter: IssueDetailPresenter?
    
    var config: Router.IssueConfig? {
        didSet {
            presenter = IssueDetailPresenter(config: config)
            presenter?.delegate = self
        }
    }
    
    @IBAction func didTapCreateComment(_ sender: Any) {
        guard let body = commentTextView.text, !body.isEmpty else { return }
        presenter?.create(comment: body)
        commentButton.isEnabled = false
        commentTextView.text = nil
    }
}

extension IssueDetailViewController: IssueDetailPresenterDelegate {
    func createdComment() {
        commentButton.isEnabled = true
        collectionView.reloadData()
        
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.collectionViewLayout.prepare()
        DispatchQueue.main.async {
            let contentSize =  self.collectionView.contentSize
            let rect = CGRect(x: contentSize.width - 1, y: contentSize.height - 1, width: 1, height: 1)
            self.collectionView.scrollRectToVisible(rect, animated: true)
        }
    }
    
    func issueDidLoaded() {
        refreshControl.endRefreshing()
        
        if let data = presenter?.model.data {
            headerView.update(data: data)
            collectionView.updateOffsetHeader()
            refreshControl.bounds.origin.y = headerView.bounds.height
        }
        
        collectionView.reloadData()
        
        if collectionView.alpha == 0 {
            UIView.animate(withDuration: .basic) {
                self.collectionView.alpha = 1
            }
        }
    }
    
}


// MARK: - Setup
extension IssueDetailViewController  {
    
    func setup() {
        collectionView.headerView = self.headerView
        collectionView.alwaysBounceVertical = true
        collectionView.alpha = 0
        
        collectionView.addSubview(refreshControl)
        refreshControl.bounds.origin.y = headerView.bounds.height
    }
    
    func eventSetup() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onChangedKeyboard), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    func refresh(sender: Any) {
        presenter?.refresh()
    }
}


extension IssueDetailViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath)
        
        guard let comment = presenter?.model.comments.datas[safe: indexPath.row] else {
            return cell
        }
        
        if let commentCell = cell as? IssueCommentCell {
            commentCell.update(data: comment, withImage: true)
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.model.comments.datas.count ?? 0
    }
}


extension IssueDetailViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 8*2
        let targetSize = CGSize(width: width, height: 48)
        
        var estimatedSize = estimatedSizes[indexPath] ?? CGSize.zero
        if estimatedSize != .zero {
            return estimatedSize
        }
        
        if let data = presenter?.model.comments.datas[safe: indexPath.row] {
            estimateCell.update(data: data, withImage: false)
        }
        
        estimatedSize = estimateCell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        estimatedSizes[indexPath] = estimatedSize
        
        return estimatedSize
    }
}



// MARK: - Notification selectors
extension IssueDetailViewController {
    
    func onChangedKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardInfo = KeyboardInfo(userInfo) else {
                return
        }
        let hidden = keyboardInfo.endFrame.origin.y >= UIScreen.main.bounds.size.height
        UIView.animate(withDuration: keyboardInfo.duration, delay: 0, options: keyboardInfo.animationOptions, animations: {
            self.commentBottomConstraint.constant = hidden ? 0 : keyboardInfo.endFrame.size.height
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
}



// MARK: - override
extension IssueDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        eventSetup()
        refresh(sender: self)
    }
}
