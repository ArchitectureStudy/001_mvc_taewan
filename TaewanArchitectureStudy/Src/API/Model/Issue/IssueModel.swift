//
//  IssueModel.swift
//  TaewanArchitectureStudy
//
//  Created by kimtaewan on 2017. 1. 16..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation
import Alamofire

//extension Notification {
//    public struct Data : RawRepresentable, Equatable, Hashable, Comparable {
//
//        var hashValue: Int {
//            return x.hashValue ^ y.hashValue
//        }
//
//        public init(_ rawValue: String) {
//
//        }
//    }
//}
//extension Notification {
//    var dataInfo: [Notification.Key: Any]? {
//        self.userInfo
//    }
//}

extension Notification.Name {
    static let IssueModelRefresh = Notification.Name("IssueModelRefresh")
}

// MARK: - Key는 Alamofire 에서 사용중인거네 나도 따라써야징
extension Notification.Key {
    static let IssuesModel = "org.alamofire.notification.key.task"
}

extension Model {
    public class IssueModel: NSObject, ModelLoadable {
        
        public private(set) var config: Router.IssueConfig
        
        public private(set) var data: DataObject.Issue?
        
        lazy var comments: CommentsModel = { [unowned self] in
            return CommentsModel(issueModel: self)
            }()
        
        
        init(config: Router.IssueConfig) {
            self.config = config
            super.init()
            addNotifications()
        }
        
        deinit {
            removeNotifications()
        }
        
        @discardableResult
        public func refresh() -> DataRequest {
            return Router.issue(config: config)
                .responseObject { [unowned self] (response: DataResponse<DataObject.Issue>) in
                    switch response.result {
                    case .success(let value):
                        self.data = value
                        
                        NotificationCenter.default.post(
                            name: .IssueModelRefresh,
                            object: self,
                            userInfo: [Notification.Key.IssuesModel: value]
                        )
                        
                    case .failure(let error):
                        debugPrint(error)
                    }
            }
        }
        
    }
}



extension Model.IssueModel {
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateIssueModel), name: .IssueModelRefresh, object: nil)//object 에서 무슨일을 하는지 알려주세요!
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateIssueModel(_ notification: Notification) {
        guard let model = notification.object as? Model.IssueModel,
            let userInfo = notification.userInfo else { return }
        if model == self {
            print("updateIssueModel: 자기자신은 패스!!")
            return
        }
        //여기는 나중에 생각하자 사시ㅏㄹ 여기 탈일도 없..
//        model.config
        
        
        //as? DataObject.Issue
        //data: DataObject.Issue
    }
}
