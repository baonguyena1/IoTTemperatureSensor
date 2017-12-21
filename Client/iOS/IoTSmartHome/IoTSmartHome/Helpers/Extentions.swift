//
//  Extentions.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/18/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return self.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var maskToBounds: Bool {
        get {
            return self.layer.masksToBounds
        }
        set {
            self.layer.masksToBounds = newValue
        }
    }
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let borderColor = self.layer.borderColor
            if borderColor != nil {
                return UIColor(cgColor: borderColor!)
            }
            return .white
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
}

typealias AlertActionHandler = ((UIAlertAction) -> Void)

extension UIAlertControllerStyle {
    func controller(title: String?, message: String?, actions:[UIAlertAction]) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: self)
        actions.forEach {
            controller.addAction($0)
        }
        return controller
    }
}

extension String {
    func alertAction(style: UIAlertActionStyle = .default, handler: AlertActionHandler? = nil) -> UIAlertAction {
        return UIAlertAction(title: self, style: style, handler: handler)
    }
    
    func mongoDBToDate() -> Date {
        let formatter = DateFormatter()
        
        // Format 1
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let parsedDate = formatter.date(from: self) {
            return parsedDate
        }
        return Date()
    }
}
