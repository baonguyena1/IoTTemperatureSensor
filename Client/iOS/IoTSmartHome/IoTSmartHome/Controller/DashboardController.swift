//
//  DashboardController.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/19/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit
import SocketIO

class DashboardController: UITableViewController {
    
    //MARK IBOutlet
    @IBOutlet fileprivate weak var temperatureLabel: UILabel!
    @IBOutlet fileprivate weak var humidityLabel: UILabel!
    @IBOutlet fileprivate weak var fanImageView: UIImageView!
    @IBOutlet fileprivate weak var fanStatusLabel: UILabel!
    @IBOutlet fileprivate weak var fanSwitch: UISwitch!
    
    fileprivate struct FanImage {
        static let FanOnImage = #imageLiteral(resourceName: "Fan_On")
        static let FanOffImage = #imageLiteral(resourceName: "Fan_Off")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func fanSwitchTapped(_ sender: UISwitch) {
        Logger.log("Status = \(sender.isOn)")
        
    }
}
