//
//  SettingController.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/19/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD

class SettingController: UITableViewController {
    
    @IBOutlet weak var manualSwitch: UISwitch!
    @IBOutlet weak var fanOnLabel: UILabel!
    @IBOutlet weak var fanOffLabel: UILabel!
    
    fileprivate var setting: Setting! {
        didSet {
            manualSwitch.isOn = setting.manualSetting
            fanOnLabel.text = "\(Message.FAN_ON_WHEN_TEMP_GREATER_THAN) \(setting.highTemp)\(Message.TEMP_SYMBOL)C"
            fanOnLabel.textColor = setting.highTempEnable ? .black : .gray
            fanOffLabel.text = "\(Message.FAN_OFF_WHEN_TEMP_LESS_THAN) \(setting.lowTemp)\(Message.TEMP_SYMBOL)C"
            fanOffLabel.textColor = setting.lowTempEnable ? .black : .gray
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getSetting(from: Service.shared, with: ServerURL.getSetting)
    }
    
    fileprivate func getSetting<S: Serviceable>(from service: S, with url: String) {
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
                let setting = Setting(with: response.results as! JSON)
                DispatchQueue.main.async { [unowned self] in
                    self.setting = setting
                }
                
            case .error(let error):
                Logger.log("Error - \(error)")
                showDefaultAlert()
            }
        }
    }

    @IBAction func manualSettingTapped(_ sender: UISwitch) {
        let setting = sender.isOn
        manualSwitch.isOn = !setting;
        Logger.log("manual setting = \(setting)")
        SocketIOManager.shared.updateManualSetting(with: sender.isOn) { [weak self] (success) in
            Logger.log("Response status = \(success)")
            self?.manualSwitch.isOn = success
        }
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        let alert = UIAlertControllerStyle.alert.controller(title: nil,
                                                            message: Language.shared.value(for: LanguageKey.logoutMessage),
                                                            actions: [
                                                                Language.shared.value(for: LanguageKey.cancel).alertAction(style: .destructive, handler: nil),
                                                                Language.shared.value(for: LanguageKey.ok).alertAction(style: .default, handler: { [weak self] (action) in
                                                                    self?.logout()
                                                                })
            ])
        showAlert(alert)
    }
    
    fileprivate func logout() {
        self.logout(from: Service.shared, with: ServerURL.logout)
    }
    
    fileprivate func logout<S: Serviceable>(from service: S, with url: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        service.get(url) { (result) in
            switch result {
            case .success(let response):
                Logger.log("JSON = \(response)")
                let response = response as! Response
                if response.success == true {
                    User.delete()
                    appDelegate.redirectVC()
                }
            case .error(let error):
                Logger.log("Error - \(error)")
                showDefaultAlert()
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
