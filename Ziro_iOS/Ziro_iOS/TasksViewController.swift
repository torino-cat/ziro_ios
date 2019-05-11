//
//  TasksViewController.swift
//  Ziro_iOS
//
//  Created by Raman Khilko on 5/3/19.
//  Copyright © 2019 Raman Khilko. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {

    let ziroWeb = ZiroWeb()
    var tasks: [ZTask]?
    var filteredTasks: [ZTask]?
    
    var taskSource: [ZTask]? {
        return filteredTasks ?? tasks
    }
    
    private var selectedTask: ZTask?
    
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    let statusColors = [
        0: UIColor(red: 76/255.0, green: 82/255.0, blue: 91/255.0, alpha: 1),
        1: UIColor(red: 8/255.0, green: 168/255.0, blue: 99/255.0, alpha: 1),
        2: UIColor(red: 237/255.0, green: 230/255.0, blue: 23/255.0, alpha: 1),
        3: UIColor(red: 232/255.0, green: 144/255.0, blue: 4/255.0, alpha: 1),
        4: UIColor(red: 15/255.0, green: 68/255.0, blue: 191/255.0, alpha: 1),
    ]
    
    let priorColors = [
        0: UIColor(red: 244/255.0, green: 199/255.0, blue: 0/255.0, alpha: 1),
        1: UIColor(red: 249/255.0, green: 197/255.0, blue: 99/255.0, alpha: 1),
        2: UIColor(red: 247/255.0, green: 161/255.0, blue: 2/255.0, alpha: 1),
        3: UIColor(red: 247/255.0, green: 92/255.0, blue: 2/255.0, alpha: 1),
        4: UIColor(red: 247/255.0, green: 14/255.0, blue: 2/255.0, alpha: 1),
    ]
    
    private var selectedSorting = 0
    
    @IBAction func sortSegmentChanged(_ sender: UISegmentedControl) {
        filteredTasks = nil
        self.selectedSorting = sender.selectedSegmentIndex
        if selectedSorting == 1 {
            filteredTasks = tasks?.filter({$0.priorityNum > 1})
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refreshControl
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Загружаю данные...")
        // Do any additional setup after loading the view.
        ziroWeb.getUserTasks { [weak self] (success, errors, tasks) in
            guard let self = self else { return }
            if success, let tasks = tasks, tasks.count > 0 {
                self.tasks = tasks
                self.tasks?.sort(by: { (t1, t2) -> Bool in
                    return t1.priorityNum > t2.priorityNum
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else if let errors = errors {
                self.handle(errors: errors)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaskDetails" {
            guard let detailController = segue.destination as? TaskDetailViewController,
                let task = selectedTask else { return }
            detailController.taskId = task.id
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        filteredTasks = nil
        tasks = nil
        
        ziroWeb.getUserTasks { [weak self] (success, errors, tasks) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            if success, let tasks = tasks, tasks.count > 0 {
                self.tasks = tasks
                self.tasks?.sort(by: { (t1, t2) -> Bool in
                    return t1.priorityNum > t2.priorityNum
                })
                self.filteredTasks = nil
                if self.selectedSorting == 1 {
                    self.filteredTasks = self.tasks?.filter({$0.priorityNum > 1})
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else if let errors = errors {
                self.handle(errors: errors)
            }
        }
    }
}

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        if
            let statusView = cell.viewWithTag(100),
            let numLabel = cell.viewWithTag(101) as? UILabel,
            let priorityLabel = cell.viewWithTag(102) as? UILabel,
            let descriptionLabel = cell.viewWithTag(103) as? UILabel,
            let task = self.taskSource?[indexPath.row] {
            statusView.layer.cornerRadius = statusView.frame.height / 4.0
            statusView.backgroundColor = self.statusColors[task.statusNum]
            numLabel.text = task.number
            priorityLabel.text = task.priority
            priorityLabel.textColor = self.priorColors[task.priorityNum] ?? UIColor.black
            descriptionLabel.text = task.title
        }
        
        return cell
    }
}

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedTask = nil
        guard let tasks = taskSource, indexPath.row >= 0, indexPath.row < tasks.count else { return nil }
        selectedTask = tasks[indexPath.row]
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
