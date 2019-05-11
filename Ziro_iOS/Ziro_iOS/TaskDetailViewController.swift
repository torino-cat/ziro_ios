//
//  TaskDetailViewController.swift
//  Ziro_iOS
//
//  Created by Roman Khilko on 5/10/19.
//  Copyright © 2019 Raman Khilko. All rights reserved.
//

import UIKit

class TaskDetailViewController: UITableViewController {

    var taskId: String!
    let ziroWeb = ZiroWeb()
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var controlLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var estimationLabel: UILabel!
    @IBOutlet weak var spentLabel: UILabel!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var logLabel: UILabel!
    
    private var projectId: String = ""
    private var taskProject: Project?
    private var logs: [LogItem] = []
    private var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ziroWeb.getTaskDetail(by: taskId) { [weak self] (success, errors, taskDetails) in
            guard let self = self else { return }
            if success, let task = taskDetails {
                self.projectId = task.projectId
                self.logs = task.logs
                self.comments = task.comments
                DispatchQueue.main.async {
                    self.numLabel.text = task.number
                    self.titleLabel.text = task.title
                    self.typeLabel.text = task.type
                    self.detailLabel.text = task.description
                    self.controlLabel.text = task.priority
                    self.dateLabel.text = task.creationDate
                    self.estimationLabel.text = "\(task.estimatedTime)"
                    self.spentLabel.text = "\(task.spentTime)"
                    self.projectLabel.text = task.projectName
                    self.commentsLabel.text = "\(task.comments.count)"
                    self.logLabel.text = "\(task.logs.count)"
                }
            } else if let errors = errors {
                self.handle(errors: errors)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProjectDetails",
            let vc = segue.destination as? ProjectDetailViewController,
            let project = self.taskProject {
            vc.project = project
        } else if segue.identifier == "Logs",
            let vc = segue.destination as? LogsViewController {
            vc.logs = self.logs
        } else if segue.identifier == "Comments",
            let vc = segue.destination as? CommentsViewController {
            vc.taskId = self.taskId
            vc.comments = self.comments
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            switch cell.tag {
            case 100: alert(withDetail: titleLabel.text)
            case 101: alert(withDetail: detailLabel.text)
            case 300:
                ziroWeb.getUserProjects { (success, errors, projects) in
                    if success, let projects = projects {
                        self.taskProject = projects.first(where: {$0.id == self.projectId})
                        if self.taskProject != nil {
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "ProjectDetails", sender: self)
                            }
                        }
                    } else if let errors = errors {
                        self.handle(errors: errors)
                    }
                }
            case 600: dismiss(animated: true, completion: nil)
            default: break
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func alert(withDetail detailText: String?) {
        let alert = UIAlertController(title: nil, message: detailText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
