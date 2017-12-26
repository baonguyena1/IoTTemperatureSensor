//
//  ServerURL.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/23/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import Foundation

struct ServerURL {
    private static let baseURL = "http://localhost"
    private static let port = "9898"
    private static let url = "\(baseURL):\(port)"
    
    static let register = "\(url)/auth/register"
    static let login = "\(url)/auth/login"
    static let logout = "\(url)/auth/logout"
    static let getSetting = "\(url)/setting/setting"
    static let getStatus = "\(url)/status"
    
}
