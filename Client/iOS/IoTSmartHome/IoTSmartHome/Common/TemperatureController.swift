//
//  TemperatureController.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/19/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

protocol TemperatureDelegate: NSObjectProtocol {
    func temperature(_ temperatureController: TemperatureController, didSelected value: String);
    func temperatureDidCancel(_ temperatureController: TemperatureController)
}

class TemperatureController: UIViewController {
    
    @IBOutlet fileprivate weak var temperaturePickerView: UIPickerView!
    @IBOutlet fileprivate weak var cancelButton: UIBarButtonItem!
    @IBOutlet fileprivate weak var doneButton: UIBarButtonItem!
    
    fileprivate let filename = "Temperature"
    
    fileprivate lazy var dataSource: [Any] = {
        if let path = Bundle.main.path(forResource: filename, ofType: "plist") {
            let datas = NSArray(contentsOfFile: path) as! [Any]
            return datas
        }
        return []
    }()
    
    fileprivate var prefix: String!
    fileprivate var suffix: String!
    
    weak var delegate: TemperatureDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
    }
    
    fileprivate func initData() {
        let firstData = self.dataSource[0] as! [String]
        self.temperaturePickerView.selectRow(firstData.count/2, inComponent: 0, animated: true)
        let secondData = self.dataSource[1] as! [String]
        self.temperaturePickerView.selectRow(secondData.count/2, inComponent: 1, animated: true)
        prefix = firstData[firstData.count/2]
        suffix = secondData[secondData.count/2]
    }

    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        delegate?.temperatureDidCancel(self)
    }
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        let data = prefix + suffix
        delegate?.temperature(self, didSelected: data)
    }
}

extension TemperatureController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.dataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let datas = self.dataSource[component] as! [String]
        return datas.count
    }
}

extension TemperatureController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let datas = self.dataSource[component] as! [String]
        return datas[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let datas = self.dataSource[component] as! [String]
        if component == 0 {
            prefix = datas[row]
        } else if component == 1 {
            suffix = datas[row]
        }
    }
}
