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

    @IBAction func manualSettingTapped(_ sender: UISwitch) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let setting = sender.isOn
        manualSwitch.isOn = !setting;
        Logger.log("manual setting = \(setting)")
        SocketIOManager.shared.updateManualSetting(with: sender.isOn) { [weak self] (success) in
            Logger.log("Response status = \(success)")
            self?.manualSwitch.isOn = success
            MBProgressHUD.hide(for: self!.view, animated: true)
        }
    }
}
