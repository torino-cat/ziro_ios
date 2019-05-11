//
//  ZiroWeb.swift
//  Ziro_iOS
//
//  Created by Raman Khilko on 5/1/19.
//  Copyright © 2019 Raman Khilko. All rights reserved.
//

import Foundation

class ZiroWeb {
    
    private static let api = "http://ziroweb.azurewebsites.net/api"
    
    func signIn(withEmail email: String, andPassword passwod: String, completionHandler: @escaping (_ success: Bool, _ errors: [String]?) -> Void) {
        let json: [String: Any] = ["email": email,
                                   "password": passwod]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let loginUrl = URL(string: "\(ZiroWeb.api)/Account/Login")!
        var loginRequest = URLRequest(url: loginUrl)
        loginRequest.httpMethod = "POST"
        loginRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        loginRequest.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: loginRequest) { (data, response, error) in
            if let error = error {
                completionHandler(false, [error.localizedDescription])
                return
            }
            print(response!)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completionHandler(false, ["Операция завершена неудачно"])
                return
            }
            guard
                let data = data,
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []),
                let responseData = responseJSON as? [String: Any]
            else {
                completionHandler(false, ["Данные не получены"])
                return
            }
            let errors = responseData["errors"] as? [String]
            completionHandler(errors == nil, errors)
        }
        
        task.resume()
    }
    
    func signOut(completionHandler: @escaping () -> Void) {
        let logoutUrl = URL(string: "\(ZiroWeb.api)/Account/Logout")!
        let task = URLSession.shared.dataTask(with: logoutUrl) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(response!)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
            completionHandler()
        }
        task.resume()
    }
    
    func testUser() {
        let testUrl = URL(string: "\(ZiroWeb.api)/Test/TestUser")!
        let testTask = URLSession.shared.dataTask(with: testUrl) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(response!)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        testTask.resume()
    }
    
    func getUserProjects(withCompletion completion: @escaping (_ success: Bool, _ errors: [String]?, _ projects: [Project]?) -> Void) {
        
        let projectsUrl = URL(string: "\(ZiroWeb.api)/project/getCurrentProjects")!
        let task = URLSession.shared.dataTask(with: projectsUrl) { (data, response, error) in
            if let error = error {
                completion(false, [error.localizedDescription], nil)
                return
            }
            print(response!)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion(false, ["Операция завершена неудачно"], nil)
                return
            }
            guard
                let data = data,
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []),
                let responseData = responseJSON as? [String: Any]
                else {
                    completion(false, ["Данные не получены"], nil)
                    return
            }
            let errors = responseData["errors"] as? [String]
            if errors != nil {
                completion(false, errors, nil)
            }
            guard
                let dataNode = responseData["data"] as? [String: Any],
                let projectNode = dataNode["projects"] as? [[String: Any]]
                else {
                    completion(false, ["Некорректные данные"], nil)
                    return
            }
            let projects = projectNode.compactMap(Project.init)
            completion(true, nil, projects)
        }
        task.resume()
    }
    
    func getUserInfo(withCompletion completion: @escaping (_ success: Bool, _ errors: [String]?, _ account: AccountInfo?) -> Void) {
        let url = URL(string: "\(ZiroWeb.api)/user/getProfile")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(false, [error.localizedDescription], nil)
                return
            }
            print(response!)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion(false, ["Операция завершена неудачно"], nil)
                return
            }
            guard
                let data = data,
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []),
                let responseData = responseJSON as? [String: Any]
                else {
                    completion(false, ["Данные не получены"], nil)
                    return
            }
            let errors = responseData["errors"] as? [String]
            if errors != nil {
                completion(false, errors, nil)
            }
            guard
                let dataNode = responseData["data"] as? [String: Any]
                else {
                    completion(false, ["Некорректные данные"], nil)
                    return
            }
            let account = AccountInfo(dataNode)
            completion(true, nil, account)
        }
        task.resume()
    }
    
    func getUserTasks(withCompletion completion: @escaping (_ success: Bool, _ errors: [String]?, _ projects: [ZTask]?) -> Void) {
        
        let taskUrl = URL(string: "\(ZiroWeb.api)/task/getCurrentTasks")!
        let task = URLSession.shared.dataTask(with: taskUrl) { (data, response, error) in
            if let error = error {
                completion(false, [error.localizedDescription], nil)
                return
            }
            print(response!)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion(false, ["Операция завершена неудачно"], nil)
                return
            }
            guard
                let data = data,
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []),
                let responseData = responseJSON as? [String: Any]
                else {
                    completion(false, ["Данные не получены"], nil)
                    return
            }
            let errors = responseData["errors"] as? [String]
            if errors != nil {
                completion(false, errors, nil)
            }
            guard
                let dataNode = responseData["data"] as? [String: Any],
                let taskNode = dataNode["tasks"] as? [[String: Any]]
                else {
                    completion(false, ["Некорректные данные"], nil)
                    return
            }
            let tasks = taskNode.compactMap(ZTask.init)
            completion(true, nil, tasks)
        }
        task.resume()
    }
    
    func getTaskDetail(by taskId: String, withCompletion completion: @escaping (_ success: Bool, _ errors: [String]?, _ account: TaskDetail?) -> Void) {
        let url = URL(string: "\(ZiroWeb.api)/task/getTaskDetails")!
        
        let json: [String: Any] = ["taskId": taskId]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(false, [error.localizedDescription], nil)
                return
            }
            print(response!)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion(false, ["Операция завершена неудачно"], nil)
                return
            }
            guard
                let data = data,
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []),
                let responseData = responseJSON as? [String: Any]
                else {
                    completion(false, ["Данные не получены"], nil)
                    return
            }
            let errors = responseData["errors"] as? [String]
            if errors != nil {
                completion(false, errors, nil)
            }
            guard
                let dataNode = responseData["data"] as? [String: Any]
                else {
                    completion(false, ["Некорректные данные"], nil)
                    return
            }
            let taskDetails = TaskDetail(dataNode)
            completion(true, nil, taskDetails)
        }
        task.resume()
    }
    
    func addComment(for taskId: String, withText text: String, withCompletion completion: @escaping (_ success: Bool, _ errors: [String]?, _ comment: Comment?) -> Void) {
        let comment = Comment(["text": text, "leavingDate": "11.05.2019"])
        completion(true, nil, comment)
    }
    
    func getPriors() -> [Int: String] {
        return [
            0:"Тривиальный",
            1:"Низкий",
            2:"Высокий",
            3:"Критический",
            4:"Блокирующий"
        ]
    }
}
