//
//  TasksViewController.swift
//  Ziro_iOS
//
//  Created by Raman Khilko on 5/3/19.
//  Copyright © 2019 Raman Khilko. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        cell.textLabel?.text = "11"
        return cell
    }
}

extension TasksViewController: UITableViewDelegate {
    
}
