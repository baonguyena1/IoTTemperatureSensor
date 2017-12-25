//
//  Language.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/25/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

enum LanguageType: Int {
    case englist, vietnamese
}

struct Language {
    static let shared = Language(with: .englist)
    
    fileprivate var type: LanguageType!
    fileprivate var datas: JSON!
    
    init(with type: LanguageType) {
        self.type = type
        self.datas = self.initWith(languageType: type)
    }
    
    fileprivate func initWith(languageType: LanguageType) -> JSON {
        var filename: String
        switch languageType {
        case .englist:
            filename = "English"
        case .vietnamese:
            filename = "Vietnamese"
        }
        let path = Bundle.main.path(forResource: filename, ofType: "plist")
        if let datas =  NSDictionary(contentsOfFile: path!) as? JSON {
            return datas
        }
        return JSON()
    }
    
    mutating func language(with type: LanguageType) {
        self.datas = self.initWith(languageType: type)
    }
    
    func value(for key: String) -> String {
        return self.datas[key] as? String ?? ""
    }
    
}
