//
//  ProjectDetailViewController.swift
//  Ziro_iOS
//
//  Created by Raman Khilko on 5/5/19.
//  Copyright © 2019 Raman Khilko. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UITableViewController {

    var project: Project!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shortNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var toDoLabel: UILabel!
    @IBOutlet weak var inProgressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = project.name
        shortNameLabel.text = project.shortName
        descriptionLabel.text = project.description
        toDoLabel.text = "\(project.todoTaskCount) задач"
        inProgressLabel.text = "\(project.inProgressTaskCount) задач"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            dismiss(animated: true, completion: nil)
        } else {
            if let cell = tableView.cellForRow(at: indexPath), cell.tag == 100 {
                let alert = UIAlertController(title: nil, message: descriptionLabel.text, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
