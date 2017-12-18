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
