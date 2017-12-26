//
//  Setting.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/21/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

struct Setting {
    var id: String
    var userId: String
    var manualSetting: Bool
    var highTempEnable: Bool
    var highTemp: Float
    var lowTempEnable: Bool
    var lowTemp: Float
    var created_at: Date
    var updated_at: Date
    
    init(with json: JSON) {
        id = json[KeyString.id] as! String
        userId = json[KeyString.userId] as! String
        manualSetting = json[KeyString.manualSetting] as! Bool
        highTempEnable = json[KeyString.highTempEnable] as! Bool
        highTemp = json[KeyString.highTemp] as! Float
        lowTempEnable = json[KeyString.lowTempEnable] as! Bool
        lowTemp = json[KeyString.lowTemp] as! Float
        created_at = (json[KeyString.created_at] as! String).mongoDBToDate()
        updated_at = (json[KeyString.updated_at] as! String).mongoDBToDate()
    }
}
