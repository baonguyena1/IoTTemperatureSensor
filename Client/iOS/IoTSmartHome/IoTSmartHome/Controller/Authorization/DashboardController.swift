//
//  DashboardController.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/19/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD

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
    
    fileprivate var status: Status! {
        didSet {
            self.temperatureLabel.text = "\(self.status.temperature)\(Message.TEMP_SYMBOL)C"
            self.humidityLabel.text = "\(self.status.humidity)%"
            self.fanImageView.image = self.status.fanStatus ? FanImage.FanOnImage : FanImage.FanOffImage
            self.fanStatusLabel.text = self.status.fanStatus ? "Fan On" : "Fan Off"
            self.fanSwitch.isOn = self.status.fanStatus
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SocketIOManager.shared.didUpdateTemperature = { [weak self] datas in
            guard let strongSelf = self, let datas = datas else {
                return
            }
            let temp: Float = datas[KeyString.temperature] as! Float
            let humidity: Float = datas[KeyString.humidity] as! Float
            DispatchQueue.main.async {
                strongSelf.temperatureLabel.text = "\(temp)\(Message.TEMP_SYMBOL)C"
                strongSelf.humidityLabel.text = "\(humidity)%"
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getStatus(from: Service.shared, with: ServerURL.getStatus)
    }

    @IBAction func fanSwitchTapped(_ sender: UISwitch) {
        let status = sender.isOn
        SocketIOManager.shared.updateFan(with: status)
        self.fanImageView.image = status ? FanImage.FanOnImage : FanImage.FanOffImage
        self.fanStatusLabel.text = status ? "Fan On" : "Fan Off"
    }
    
    fileprivate func getStatus<S: Serviceable>(from service: S, with url: String) {
        service.get(url) { [unowned self] (result) in
            switch result {
            case .success(let response):
                Logger.log("JSON = \(response)")
                guard let response = response as? Response else {
                    return
                }
                if response.success == false {
                    return
                }
                let status = Status(with: response.results as! JSON)
                DispatchQueue.main.async { [unowned self] in
                    self.status = status
                }
                
            case .error(let error):
                Logger.log("Error - \(error)")
            }
        }
    }
}
