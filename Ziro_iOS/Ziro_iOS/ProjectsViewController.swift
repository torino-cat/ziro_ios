//
//  ProjectsViewController.swift
//  Ziro_iOS
//
//  Created by Raman Khilko on 5/5/19.
//  Copyright © 2019 Raman Khilko. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController {

    let ziroWeb = ZiroWeb()
    var projects: [Project]?
    var filteredProjects: [Project]?
    private var selectedProject: Project?
    
    var projectSource: [Project]? {
        return filteredProjects ?? projects
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private var searchText: String?
    private var selectedSorting = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refreshControl
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Загружаю данные...")
        // Do any additional setup after loading the view.
        ziroWeb.getUserProjects { [weak self] (success, errors, projects) in
            guard let self = self else { return }
            if success, let projects = projects, projects.count > 0 {
                self.projects = projects
                self.projects?.sort(by: { (p1, p2) -> Bool in
                    return p1.name <= p2.name
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProjectDetails" {
            guard let detailController = segue.destination as? ProjectDetailViewController,
            let project = selectedProject else { return }
            detailController.project = project
        }
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        filteredProjects = nil
        self.selectedSorting = sender.selectedSegmentIndex
        projects?.sort(by: { (p1, p2) -> Bool in
            return sender.selectedSegmentIndex == 0 ? p1.name <= p2.name : p1.projectIndex >= p2.projectIndex
        })
        if let text = self.searchText {
            filteredProjects = projects?.filter({$0.name.contains(text)})
        }
        tableView.reloadData()
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        filteredProjects = nil
        projects = nil
        
        ziroWeb.getUserProjects { [weak self] (success, errors, projects) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            if success, let projects = projects, projects.count > 0 {
                self.projects = projects
                self.projects?.sort(by: { (p1, p2) -> Bool in
                    return self.selectedSorting == 0 ? p1.name <= p2.name : p1.projectIndex >= p2.projectIndex
                })
                if let text = self.searchText {
                    self.filteredProjects = self.projects?.filter({$0.name.contains(text)})
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension ProjectsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath)
        if let project = projectSource?[indexPath.row] {
            cell.textLabel?.text = project.name
            let projectStatus = "Запланированно: \(project.todoTaskCount) задач, в процессе: \(project.inProgressTaskCount)"
            cell.detailTextLabel?.text = projectStatus
        }
        return cell
    }
}

extension ProjectsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedProject = nil
        guard let projects = projectSource, indexPath.row >= 0, indexPath.row < projects.count else { return nil }
        selectedProject = projects[indexPath.row]
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProjectsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.count > 2 else { return }
        searchText = text
        filteredProjects = projects?.filter({$0.name.contains(text)})
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.searchText = nil
            filteredProjects = nil
            self.tableView.reloadData()
        }
    }
}
