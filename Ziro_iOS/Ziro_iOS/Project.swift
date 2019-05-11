//
//  Project.swift
//  Ziro_iOS
//
//  Created by Raman Khilko on 5/5/19.
//  Copyright © 2019 Raman Khilko. All rights reserved.
//

import Foundation

class Project {
    var id: String = ""
    var name: String = ""
    var shortName: String = ""
    var description: String = ""
    var todoTaskCount = 0
    var inProgressTaskCount = 0
    
    var projectIndex: Int {
        return todoTaskCount + inProgressTaskCount
    }
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.shortName = dictionary["shortName"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.todoTaskCount = dictionary["tasksOpenCount"] as? Int ?? 0
        self.inProgressTaskCount = dictionary["tasksInProgressCount"] as? Int ?? 0
    }
}
