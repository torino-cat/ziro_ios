//
//  AccountViewController.swift
//  Ziro_iOS
//
//  Created by Raman Khilko on 5/6/19.
//  Copyright © 2019 Raman Khilko. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var skypeLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!

    let ziroWeb = ZiroWeb()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ziroWeb.getUserInfo { [weak self] (success, errors, account) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if success, let account = account {
                    self.emailLabel.text = account.email
                    self.firstNameLabel.text = account.firstName
                    self.lastNameLabel.text = account.lastName
                    self.skypeLabel.text = account.skype
                    self.phoneLabel.text = account.phoneNumber
                    self.dobLabel.text = account.dateOfBirth
                } else if let errors = errors {
                    self.handle(errors: errors)
                }
            }
        }
    }

    // MARK: - Table view data source
}
