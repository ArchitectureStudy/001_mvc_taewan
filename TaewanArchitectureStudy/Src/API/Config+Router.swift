//
//  Config+Model.swift
//  TaewanArchitectureStudy
//
//
//  이런건 파일명을 뭐라고하지..
//
//  Created by taewan on 2017. 1. 21..
//  Copyright © 2017년 taewankim. All rights reserved.
//

import Foundation

extension Router {
    public struct RepositoryConfig {
        public let user: String
        public let repo: String
        init?(user: String?, repo: String?) {
            guard let user = user, let repo = repo else {
                assertionFailure()
                return nil
            }
            self.user = user
            self.repo = repo
        }
    }
    
    public struct IssueConfig {
        public let repository: RepositoryConfig
        public let number: Int
        init?(repository: RepositoryConfig?, number: Int?) {
            guard let repository = repository, let number = number else {
                assertionFailure()
                return nil
            }
            
            self.repository = repository
            self.number = number
        }
    }
}


extension Router.RepositoryConfig: Equatable {
    public static func ==(lhs: Router.RepositoryConfig, rhs: Router.RepositoryConfig) -> Bool {
        return lhs.user == rhs.user && lhs.repo == rhs.repo
    }
}

extension Router.IssueConfig: Equatable {
    public static func ==(lhs: Router.IssueConfig, rhs: Router.IssueConfig) -> Bool {
        return lhs.repository == rhs.repository && lhs.number == rhs.number
    }
}
