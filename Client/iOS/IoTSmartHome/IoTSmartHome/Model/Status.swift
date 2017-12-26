//
//  Status.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/26/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

struct Status {
    var id: String
    var userId: String
    var temperature: Float
    var humidity: Float
    var fanStatus: Bool
    var created_at: Date
    var updated_at: Date
    
    init(with json: JSON) {
        id = json[KeyString.id] as! String
        userId = json[KeyString.userId] as! String
        temperature = json[KeyString.temperature] as! Float
        humidity = json[KeyString.humidity] as! Float
        fanStatus = json[KeyString.fanStatus] as! Bool
        created_at = (json[KeyString.created_at] as! String).mongoDBToDate()
        updated_at = (json[KeyString.updated_at] as! String).mongoDBToDate()
    }
}
