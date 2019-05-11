//
//  TaskDetail.swift
//  Ziro_iOS
//
//  Created by Roman Khilko on 5/10/19.
//  Copyright © 2019 Raman Khilko. All rights reserved.
//

import Foundation

class Comment {
    var id: String = ""
    var authorId = ""
    var authorName = ""
    var text = ""
    var date = ""
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.date = dictionary["leavingDate"] as? String ?? ""
        if let author = dictionary["author"] as? [String: Any] {
            self.authorId = author["id"] as? String ?? ""
            self.authorName = author["fullName"] as? String ?? ""
        }
    }
}

class LogItem {
    var id: String = ""
    var authorId = ""
    var authorName = ""
    var text = ""
    var date = ""
    var spentTimeHours = 0
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.date = dictionary["leavingDate"] as? String ?? ""
        self.spentTimeHours = dictionary["spentTimeHours"] as? Int ?? 0
        if let author = dictionary["author"] as? [String: Any] {
            self.authorId = author["id"] as? String ?? ""
            self.authorName = author["fullName"] as? String ?? ""
        }
    }
}

class TaskDetail: ZTask {
    var estimatedTime = 0
    var spentTime = 0
    var creationDate = ""
    var lastUpdateDate = ""
    var projectId = ""
    var projectName = ""
    var comments: [Comment] = []
    var logs: [LogItem] = []
    
    override init(_ dictionary: [String: Any]) {
        super.init(dictionary)
        self.estimatedTime = dictionary["estimatedTime"] as? Int ?? 0
        self.spentTime = dictionary["spentTime"] as? Int ?? 0
        self.creationDate = dictionary["creationDate"] as? String ?? ""
        self.lastUpdateDate = dictionary["lastUpdateDate"] as? String ?? ""
        if let project = dictionary["project"] as? [String: Any] {
            self.projectId = project["id"] as? String ?? ""
            self.projectName = project["name"] as? String ?? ""
        }
        if let commentsNode = dictionary["comments"] as? [[String: Any]] {
            self.comments = commentsNode.compactMap(Comment.init)
        }
        if let logsNode = dictionary["logWorks"] as? [[String: Any]] {
            self.logs = logsNode.compactMap(LogItem.init)
        }
    }
}
