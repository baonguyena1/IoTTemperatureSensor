//
//  GeneralFunction.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/25/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

var rootViewController: UIViewController {
    return UIApplication.shared.keyWindow!.rootViewController!
}

var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

func showAlert(_ alert: UIAlertController) {
    rootViewController.present(alert, animated: true, completion: nil)
}

func showDefaultAlert() {
    let alert = UIAlertControllerStyle.alert.controller(title: Language.shared.value(for: LanguageKey.message),
                                                        message: Language.shared.value(for: LanguageKey.somethingWentWrong),
                                                        actions: [
                                                            Language.shared.value(for: LanguageKey.ok).alertAction(style: .destructive, handler: nil)
        ])
    showAlert(alert)
}
