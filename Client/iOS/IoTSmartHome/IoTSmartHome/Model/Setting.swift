//
//  Setting.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/21/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

struct Setting: Codable {
    var manualSetting: Bool
    var highTempEnable: Bool
    var highTemp: Float
    var lowTempEnable: Bool
    var lowTemp: Float
    var created_at: Date
    var updated_at: Date
    
}
