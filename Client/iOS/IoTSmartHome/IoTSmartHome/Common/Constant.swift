//
//  Constant.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/19/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

typealias JSON = [String: Any]

struct SocketIOEvent {
    static let didUpdateTemperature = "didUpdateTemperature"
    static let didUpdateManualSetting = "didUpdateManualSetting"
    static let updateManualSettingResponse = "updateManualSettingResponse"
}

struct KeyString {
    static let Temperature = "temp"
    static let Humidity = "humi"
    static let Results = "results"
    static let Success = "success"
    static let ErrorCode = "error_code"
    static let Message = "message"
    
    static let id = "_id"
    static let manualSetting = "manualSetting"
    static let highTempEnable = "highTempEnable"
    static let highTemp = "highTemp"
    static let lowTempEnable = "lowTempEnable"
    static let lowTemp = "lowTemp"
    static let created_at = "created_at"
    static let updated_at = "updated_at"
    
    static let username = "username"
    static let access_token = "access_token"
}

struct Message {
    static let SOMETHING_WRONG = "Something went wrong. Please try again!!!"
    static let TEMP_SYMBOL = "°"
    static let FAN_ON_WHEN_TEMP_GREATER_THAN = "Turn on Fan when the temperature is greater than"
    static let FAN_OFF_WHEN_TEMP_LESS_THAN = "Turn off Fan when the temperature is less than"
}

struct StoryboardIdentifier {
    static let loginNavigationController = "LoginNavigationController"
    static let tabbarViewController = "TabbarViewController"
}

enum AppStoryBoard: String {
    case Authorization
    case UnAuthorization
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: .main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyBoardID = (viewControllerClass as UIViewController.Type).storyBoardID
        return instance.instantiateViewController(withIdentifier: storyBoardID) as! T
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    class var storyBoardID: String {
        return "\(self)"
    }
    static func instantiate(from appStoryBoard: AppStoryBoard) -> Self {
        return  appStoryBoard.viewController(viewControllerClass: self)
    }
}

struct LanguageKey {
    static let message = "general.message"
    static let somethingWentWrong = "general.something-went-wrong"
    static let yes = "general.yes"
    static let no = "general.no"
    static let ok = "general.ok"
    static let cancel = "general.cancel"
    static let logoutMessage = "general.logout-message"
}
