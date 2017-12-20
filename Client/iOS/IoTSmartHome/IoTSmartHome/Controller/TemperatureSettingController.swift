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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func chooseTemperature(_ sender: UITapGestureRecognizer) {
        temperatureController = storyboard?.instantiateViewController(withIdentifier: StoryBoardIdentifier.TemperatureController) as? TemperatureController
        if let tempController = temperatureController {
            tempController.delegate = self
            if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                rootVC.view.addSubview(tempController.view)
                rootVC.addChildViewController(tempController)
                tempController.didMove(toParentViewController: self)
            }
        }
    }
    @IBAction func switchTapped(_ sender: UISwitch) {
        
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
        
    }
}
