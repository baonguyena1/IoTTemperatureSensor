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
    
    var didUpdateTemperature: ((JSON?) -> Void)?
    
    override init() {
        super.init()
        manager = SocketManager(socketURL: URL(string: ServerURL.baseURL)!, config: [.reconnects(true), .reconnectWait(60), .forcePolling(true)])
//        socket = manager.socket(forNamespace: "/client")
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { (datas, ack) in
            Logger.log("Socket is connected")
        }
        socket.on(clientEvent: .disconnect) { (datas, ack) in
            Logger.log("Socket is disconnected")
        }
        socket.on(SocketIOEvent.didUpdateTemperature) { (datas, ack) in
            let didUpdateTemperature = self.didUpdateTemperature
            didUpdateTemperature?(datas[0] as? JSON)
        }
    }
    
    func establishConnect() {
        socket.connect()
    }
    
    func closeConnect() {
        socket.disconnect()
    }
    
    func connectUser(with userId: String) {
        socket.emit(SocketIOEvent.connectUser, userId);
    }
    
    func updateManualSetting(with manualSetting: Bool) {
        socket.emit(SocketIOEvent.didUpdateManualSetting, manualSetting)
    }
    
    func updateFan(with status: Bool) {
        socket.emit(SocketIOEvent.didUpdateFanStatus, status)
    }
    
    func updateSetting(with data: JSON) {
        socket.emit(SocketIOEvent.didUpdateSetting, data)
    }
    
}
