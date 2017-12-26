//
//  TemperatureSettingController.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/19/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

class TemperatureSettingController: UITableViewController {

    fileprivate var temperatureController: TemperatureController?
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func chooseTemperature(_ sender: UITapGestureRecognizer) {
        temperatureController = TemperatureController.instantiate(from: .Authorization)
        if let tempController = temperatureController {
            tempController.delegate = self
            if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                rootVC.view.addSubview(tempController.view)
                rootVC.addChildViewController(tempController)
                tempController.didMove(toParentViewController: self)
            }
        }
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        let data: JSON = [
            KeyString.highTempEnable: enableSwitch.isOn,
            KeyString.highTemp: temperatureLabel.text!
        ]
        SocketIOManager.shared.updateSetting(with: data)
    }
}

extension TemperatureSettingController: TemperatureDelegate {
    func temperatureDidCancel(_ temperatureController: TemperatureController) {
        if let tempController = self.temperatureController {
            tempController.willMove(toParentViewController: self)
            tempController.view.removeFromSuperview()
            tempController.removeFromParentViewController()
        }
        self.temperatureController = nil
    }
    
    func temperature(_ temperatureController: TemperatureController, didSelected value: String) {
        temperatureLabel.text = value
        if let tempController = self.temperatureController {
            tempController.willMove(toParentViewController: self)
            tempController.view.removeFromSuperview()
            tempController.removeFromParentViewController()
        }
        self.temperatureController = nil
    }
}
