//
//  User.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/23/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import Foundation

struct User {
    var id: String
    var username: String
    var access_token: String
    
    init?(with json: JSON) {
        guard let id = json[KeyString.id] as? String, let username = json[KeyString.username] as? String, let access_token = json[KeyString.access_token] as? String else {
            return nil
        }
        self.id = id
        self.username = username
        self.access_token = access_token
    }
}
