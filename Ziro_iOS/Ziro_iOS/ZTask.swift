//
//  ZTask.swift
//  Ziro_iOS
//
//  Created by Roman Khilko on 5/10/19.
//  Copyright © 2019 Raman Khilko. All rights reserved.
//

import Foundation

class ZTask {
    var id: String = ""
    var number: String = ""
    var typeNum = 0
    var type: String = ""
    var statusNum = 0
    var status: String = ""
    var title: String = ""
    var description: String = ""
    var priorityNum = 0
    var priority: String = ""
    //var projectName: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.number = dictionary["number"] as? String ?? ""
        self.typeNum = dictionary["typeNum"] as? Int ?? 0
        self.type = dictionary["type"] as? String ?? ""
        self.statusNum = dictionary["statusNum"] as? Int ?? 0
        self.status = dictionary["status"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.priorityNum = dictionary["statusNum"] as? Int ?? 0
        self.priority = dictionary["priority"] as? String ?? ""
        //self.projectName = dictionary["projectName"] as? String ?? ""
    }
}
