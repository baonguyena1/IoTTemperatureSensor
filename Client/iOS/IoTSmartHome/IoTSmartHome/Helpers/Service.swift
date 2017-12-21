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
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response) in
                if let _ = response.result.error {
                    completion(.error(.responseUnsuccessful))
                } else if let result = response.result.value as? JSON {
                    let response =  Response(with: result)
                    completion(.success(response))
                } else {
                    completion(.error(.invalidData))
                }
        }
    }
    
    func post(_ url: String, with jsonData: [String : Any], completion: @escaping completionHandler) {
        
    }
}
