//
//  HTHostPingTool.swift
//  iOS
//
//  Created by yuqingyuan on 2020/9/2.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import Foundation
import OSLog

class HTHostPingTool: NSObject {
    
    private var simplePing: SimplePing? = nil
    private var sequenceNums = [UInt16]()
    private var pingCallback: ((Bool) -> ())!
    private var interval: TimeInterval!
    
    override init() {
        
    }
    
    convenience init(host: String, timeout: TimeInterval, _ callback: @escaping (Bool) -> ()) {
        self.init()
        
        simplePing = SimplePing(hostName: host)
        simplePing?.addressStyle = .any
        simplePing?.delegate = self
        
        interval = timeout
        pingCallback = callback
    }
    
    func start() {
        simplePing?.start()
    }
    
    func stop() {
        simplePing?.stop()
    }
}

extension HTHostPingTool: SimplePingDelegate {
    
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        os_log(.info, "【SimplePing】start ping %s", pinger.hostName)
        pinger.send(with: nil)
    }
    
    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        os_log(.error, "【SimplePing】error %s", error.localizedDescription)
        pinger.stop()
    }
    
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        os_log(.info, "【SimplePing】send packet %d", sequenceNumber)
        sequenceNums.append(sequenceNumber)
        // 检查是否有回包
        DispatchQueue.main.asyncAfter(deadline: .now()+interval) {
            let hasRes = !self.sequenceNums.contains(sequenceNumber)
            if !hasRes {
                os_log(.info, "【SimplePing】didn't receive response from %s", pinger.hostName)
            }
            self.pingCallback(hasRes)
            self.stop()
        }
    }
    
    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        os_log(.info, "【SimplePing】receive unexpected packet")
    }
    
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        os_log(.info, "【SimplePing】receive ping response %d", sequenceNumber)
        if let index = sequenceNums.firstIndex(of: sequenceNumber) {
            sequenceNums.remove(at: index)
        }
    }
    
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        os_log(.info, "【SimplePing】fail to send packet %d %s", sequenceNumber, error.localizedDescription)
    }
}
