//
//  Constant.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/19/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

struct SocketIOEvent {
    static let didUpdateTemperature = "didUpdateTemperature"
    static let didUpdateManualSetting = "didUpdateManualSetting"
    static let updateManualSettingResponse = "updateManualSettingResponse"
}

struct KeyString {
    static let Temperature = "temp"
    static let Humidity = "humi"
}
