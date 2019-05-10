//
//  ViewController.swift
//  Ziro_iOS
//
//  Created by Raman Khilko on 3/17/19.
//  Copyright © 2019 Raman Khilko. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginTextBox: UITextField!
    @IBOutlet weak var passwordBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginView.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
    
    @IBAction func signIn() {
        guard let login = loginTextBox.text, login.count > 0 else {
            handle(errors: ["Email должен быть заполнен"])
            return
        }
        guard let password = passwordBox.text, password.count > 0 else {
            handle(errors: ["Пароль должен быть заполнен"])
            return
        }
        ZiroWeb().signIn(withEmail: login, andPassword: password) { (success, errors) in
            if success {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "Main", sender: self)
                }
//                ZiroWeb().testUser()
//                ZiroWeb().signOut {
//                    ZiroWeb().testUser()
//                }
            } else if let errors = errors {
                self.handle(errors: errors)
            }
        }
    }
}

extension UIViewController {
    func handle(errors: [String]) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: errors.count > 0 ? errors[0] : "Произошла неизвестная ошибка", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
