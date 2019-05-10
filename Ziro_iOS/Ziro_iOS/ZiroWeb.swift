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
}
