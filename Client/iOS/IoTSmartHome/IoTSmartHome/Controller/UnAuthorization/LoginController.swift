//
//  LoginController.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/22/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        self.login(from: Service.shared, with: ServerURL.login)
    }
    
    fileprivate func login<S: Serviceable>(from service: S, with url: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let parameters: JSON = [
            KeyString.username: usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            KeyString.password: passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        ]
        service.post(url, with: parameters) { (result) in
            switch result {
            case .success(let response):
                Logger.log("JSON = \(response)")
                let response = response as! Response
                let user = User(with: response.results as! JSON)
                if user == nil {
                    showDefaultAlert()
                    return
                }
                User.save(user!)
                appDelegate.redirectVC()
            case .error(let error):
                Logger.log("Error - \(error)")
                showDefaultAlert()
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
}
