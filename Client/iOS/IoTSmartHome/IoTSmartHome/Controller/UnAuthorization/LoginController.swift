//
//  LoginController.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/22/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        
    }
    
    fileprivate func login<S: Serviceable>(from service: S, with url: String) {
        service.get(url) { (result) in
            switch result {
            case .success(let response):
                Logger.log("JSON = \(response)")
                guard let response = response as? Response else {
                    return
                }
                if response.success == false {
                    return
                }
                let user = User(with: response.results as! JSON)
                guard let userLogin = user else {
                    // Show error message
                    return
                }
                // change root view controller
                DispatchQueue.main.async { [unowned self] in
                    User.save(userLogin)
                }
                
            case .error(let error):
                Logger.log("Error - \(error)")
            }
        }
    }
}
