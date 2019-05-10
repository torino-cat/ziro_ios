//
//  AccountInfo.swift
//  Ziro_iOS
//
//  Created by Raman Khilko on 5/6/19.
//  Copyright © 2019 Raman Khilko. All rights reserved.
//

import Foundation

class AccountInfo {
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var skype: String = ""
    var phoneNumber: String = ""
    var dateOfBirth: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.firstName = dictionary["name"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.skype = dictionary["skype"] as? String ?? ""
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        self.dateOfBirth = dictionary["dateOfBirth"] as? String ?? ""
    }
}
