//
//  Result.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/21/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

struct Response {
    var results: Any?
    var success: Bool
    var error_code: Int?
    var message: String?
    
    init(with json: JSON) {
        results = json[KeyString.Results]
        success = json[KeyString.Success] as! Bool
        error_code = json[KeyString.ErrorCode] as? Int
        message = json[KeyString.Message] as? String
    }
}
