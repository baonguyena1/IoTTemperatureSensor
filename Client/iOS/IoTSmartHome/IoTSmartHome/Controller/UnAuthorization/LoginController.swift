//
//  LoginController.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/22/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        
    }
    
    fileprivate func login<S: Serviceable>(from service: S, with url: String) {
        service.get(url) { [unowned self] (result) in
            switch result {
            case .success(let response):
                Logger.log("JSON = \(response)")
                let response = response as! Response
                let user = User(with: response.results as! JSON)
                if user == nil {
                    self.showErrorMessage()
                    return
                }
                User.save(user!)
                appDelegate.redirectVC()
            case .error(let error):
                Logger.log("Error - \(error)")
                self.showErrorMessage()
            }
        }
    }
    
    func showErrorMessage() {
        let alert = UIAlertControllerStyle.alert.controller(title: nil, message: Language.shared.value(for: LanguageKey.somethingWentWrong), actions: [
            Language.shared.value(for: LanguageKey.ok).alertAction(style: .destructive, handler: nil)
            ])
        IoTSmartHome.show(alert: alert)
    }
    
}
