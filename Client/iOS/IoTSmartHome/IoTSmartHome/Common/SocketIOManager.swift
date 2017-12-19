//
//  SocketIOManager.swift
//  IoTSmartHome
//
//  Created by Bao Nguyen on 12/19/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    fileprivate var manager: SocketManager!
    fileprivate var socket: SocketIOClient!
    
    override init() {
        super.init()
        Logger.log("")
        manager = SocketManager(socketURL: URL(string: "http://localhost:9898")!, config: [.log(true), .compress])
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { (datas, ack) in
            Logger.log("Socket is connected")
        }
        socket.on(clientEvent: .disconnect) { (datas, ack) in
            Logger.log("Socket is disconnected")
        }
    }
    
    func establishConnect() {
        socket.connect()
    }
    
    func closeConnect() {
        socket.disconnect()
    }
    
}
