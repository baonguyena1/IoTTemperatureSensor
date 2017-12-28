//
//  Service.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/21/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit
import Alamofire

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case invalidURL
    case jsonParsingFailure
}

enum Result<T> {
    case success(T)
    case error(APIError)
}

protocol Serviceable {
    associatedtype T    // define generic in protocol
    func get(_ url: String, completion: @escaping (Result<T>) -> Void)
    func post(_ url: String, with jsonData: [String: Any], completion: @escaping (Result<T>) -> Void)
}

struct Service: Serviceable {
    
    static let shared = Service()
    
    typealias completionHandler = (Result<Response>) -> Void
    
    func get(_ url: String, completion: @escaping completionHandler) {
        Logger.log("Request url = \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getHeaders())
            .responseJSON { (response) in
                
                if let _ = response.result.error {
                    completion(.error(.responseUnsuccessful))
                    self.showError()
                } else if let result = response.result.value as? JSON {
                    Logger.log("Response = \(response.result.value)")
                    let response =  Response(with: result)
                    if response.success == false {
                        completion(.error(.responseUnsuccessful))
                        var token_expire = false
                        if let error_code = response.error_code, error_code == 501 {
                            token_expire = true
                        }
                        self.showError(with: response.message, token_expire: token_expire)
                    } else {
                        completion(.success(response))
                    }
                    
                } else {
                    completion(.error(.invalidData))
                    self.showError()
                }
        }
    }
    
    func post(_ url: String, with jsonData: [String : Any], completion: @escaping completionHandler) {
        Logger.log("Request url = \(url), jsonData = \(jsonData)")
        Alamofire.request(url, method: .post, parameters: jsonData, encoding: JSONEncoding.default, headers: getHeaders())
            .responseData { (response) in
                
                if let _ = response.result.error {
                    completion(.error(.responseUnsuccessful))
                    self.showError()
                } else if let data = response.result.value {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! JSON
                        let response =  Response(with: json)
                        Logger.log("Response = \(response)")
                        if response.success == false {
                            completion(.error(.responseUnsuccessful))
                            var token_expire = false
                            if let error_code = response.error_code, error_code == 501 {
                                token_expire = true
                            }
                            self.showError(with: response.message, token_expire: token_expire)
                        } else {
                            completion(.success(response))
                        }
                    } catch {
                        completion(.error(.jsonParsingFailure))
                        self.showError()
                    }
                    
                } else {
                    completion(.error(.invalidData))
                    self.showError()
                }
        }
    }
    
    fileprivate func showError(with message: String? = nil, token_expire: Bool = false) {
        
        let alert = UIAlertControllerStyle.alert.controller(title: Language.shared.value(for: LanguageKey.message),
                                                            message: message,
                                                            actions: [
                                                                Language.shared.value(for: LanguageKey.ok).alertAction(style: .destructive, handler: { (action) in
                                                                    if !token_expire {
                                                                        return
                                                                    }
                                                                    User.delete()
                                                                    appDelegate.redirectVC()
                                                                })
            ])
        DispatchQueue.main.async {
            showAlert(alert)
        }
    }
    
    fileprivate func getHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        if let access_token = User.access_token {
            headers[KeyString.access_token] = access_token
        }
        return headers
    }
    
}
