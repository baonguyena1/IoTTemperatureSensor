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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getSetting(from: Service.shared, with: "http://localhost:9898/setting/setting")
    }
    
    fileprivate func getSetting<S: Serviceable>(from service: S, with url: String) {
        service.get(url) { (result) in
            switch result {
            case .success(let json):
                Logger.log("JSON = \(json)")
            case .error(let error):
                Logger.log("Error - \(error)")
            }
        }
    }

    @IBAction func manualSettingTapped(_ sender: UISwitch) {
//        MBProgressHUD.showAdded(to: self.view, animated: true)
        let setting = sender.isOn
        manualSwitch.isOn = !setting;
        Logger.log("manual setting = \(setting)")
        SocketIOManager.shared.updateManualSetting(with: sender.isOn) { [weak self] (success) in
            Logger.log("Response status = \(success)")
            self?.manualSwitch.isOn = success
//            MBProgressHUD.hide(for: self!.view, animated: true)
        }
    }
}
