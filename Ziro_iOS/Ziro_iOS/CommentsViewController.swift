//
//  CommentsViewController.swift
//  Ziro_iOS
//
//  Created by Roman Khilko on 5/11/19.
//  Copyright © 2019 Raman Khilko. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    var comments: [Comment]!
    var taskId: String!
    let ziroWeb = ZiroWeb()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let closeButton = UIBarButtonItem(title: "Назад",  style: .plain, target: self, action: #selector(close))
        let addButton = UIBarButtonItem(title: "Добавить",  style: .plain, target: self, action: #selector(add))
        navBar.leftBarButtonItem = addButton
        navBar.rightBarButtonItem = closeButton
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func add() {
        let alert = UIAlertController(title: "Добавить комментарий", message: "Введите комментарий", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { _ in
            guard let text = alert.textFields?[0].text, text.count > 0 else {
                self.handle(errors: ["Комментарий не должен быть пустым"])
                return
            }
            self.ziroWeb.addComment(for: self.taskId, withText: text, withCompletion: { (success, errors, comment) in
                if success, let comment = comment {
                    self.comments.insert(comment, at: 0)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else if let errors = errors {
                    self.handle(errors: errors)
                }
            })
        }))
        alert.addTextField(configurationHandler: nil)
        present(alert, animated: true, completion: nil)
    }
}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        if
            let authorLabel = cell.viewWithTag(100) as? UILabel,
            let dateLabel = cell.viewWithTag(101) as? UILabel,
            let textLabel = cell.viewWithTag(102) as? UILabel {
            let comment = self.comments[indexPath.row]
            authorLabel.text = comment.authorName
            dateLabel.text = comment.date
            textLabel.text = comment.text
        }
        
        return cell
    }
}

extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
