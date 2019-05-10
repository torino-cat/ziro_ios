//
//  Project.swift
//  Ziro_iOS
//
//  Created by Raman Khilko on 5/5/19.
//  Copyright © 2019 Raman Khilko. All rights reserved.
//

import Foundation

class Project {
    var name: String = ""
    var shortName: String = ""
    var description: String = ""
    var todoTaskCount = 0
    var inProgressTaskCount = 0
    var doneTaskCount = 0
    
    var projectIndex: Int {
        return todoTaskCount + inProgressTaskCount
    }
    
    init(_ dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.shortName = dictionary["shortName"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
    }
}
