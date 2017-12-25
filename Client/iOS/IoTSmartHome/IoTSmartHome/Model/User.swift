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
    
    //MARK: public static properties
    static func save(_ user: User) {
        let standard = UserDefaults.standard
        standard.setValue(user.id, forKey: KeyString.id)
        standard.setValue(user.username, forKey: KeyString.username)
        standard.setValue(user.access_token, forKey: KeyString.access_token)
        standard.synchronize()
    }
    
    static func delete() {
        let stadard = UserDefaults.standard
        stadard.removeObject(forKey: KeyString.id)
        stadard.removeObject(forKey: KeyString.username)
        stadard.removeObject(forKey: KeyString.access_token)
        stadard.synchronize()
    }
    
    static var id: String? {
        return getInformation(with: KeyString.id) as? String
    }
    
    static var username: String? {
        return getInformation(with: KeyString.username) as? String
    }
    
    static var access_token: String? {
        return getInformation(with: KeyString.access_token) as? String
    }
    
    private static func getInformation(with key: String) -> Any? {
        let standard = UserDefaults.standard
        return standard.value(forKey: key)
    }
}
