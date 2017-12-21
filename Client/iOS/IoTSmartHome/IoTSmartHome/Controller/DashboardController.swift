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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SocketIOManager.shared.didUpdateTemperature = { [weak self] datas in
            guard let strongSelf = self, let datas = datas else {
                return
            }
            let temp: Float = datas[KeyString.Temperature] as! Float
            let humidity: Float = datas[KeyString.Humidity] as! Float
            DispatchQueue.main.async {
                strongSelf.temperatureLabel.text = "\(temp)\(Message.TEMP_SYMBOL)C"
                strongSelf.humidityLabel.text = "\(humidity)%"
            }
        }
    }

    @IBAction func fanSwitchTapped(_ sender: UISwitch) {
        Logger.log("Status = \(sender.isOn)")
        fanImageView.image = sender.isOn ? FanImage.FanOnImage : FanImage.FanOffImage
        fanStatusLabel.text = sender.isOn ? "Fan On" : "Fan Off"
    }
}
