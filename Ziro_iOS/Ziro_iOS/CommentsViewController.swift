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
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let closeButton = UIBarButtonItem(title: "Назад",  style: .plain, target: self, action: #selector(close))
        let addButton = UIBarButtonItem(title: "Добавить",  style: .plain, target: self, action: #selector(close))
        navBar.leftBarButtonItem = addButton
        navBar.rightBarButtonItem = closeButton
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
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
