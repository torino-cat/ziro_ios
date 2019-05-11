//
//  LogsViewController.swift
//  Ziro_iOS
//
//  Created by Roman Khilko on 5/11/19.
//  Copyright © 2019 Raman Khilko. All rights reserved.
//

import UIKit

class LogsViewController: UITableViewController {
    
    var logs: [LogItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 1 : logs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let closeCell = tableView.dequeueReusableCell(withIdentifier: "CloseCell", for: indexPath)
            return closeCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath)
        if
            let authorLabel = cell.viewWithTag(100) as? UILabel,
            let dateLabel = cell.viewWithTag(101) as? UILabel,
            let spentLabel = cell.viewWithTag(102) as? UILabel,
            let textLabel = cell.viewWithTag(103) as? UILabel {
            let log = self.logs[indexPath.row]
            authorLabel.text = log.authorName
            dateLabel.text = log.date
            spentLabel.text = "Затратил часов: \(log.spentTimeHours)"
            textLabel.text = log.text
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 40.0 : 120.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
