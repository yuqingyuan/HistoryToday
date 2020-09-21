//
//  HTHostPingTool.swift
//  iOS
//
//  Created by yuqingyuan on 2020/9/2.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import Foundation
import os

fileprivate let logger = Logger(subsystem: "com.qingyuanyu.HistoryToday", category: "Ping")

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
        logger.info("start ping \(pinger.hostName)")
        pinger.send(with: nil)
    }
    
    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        logger.error("error \(error.localizedDescription)")
        pinger.stop()
    }
    
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        logger.info("send packet \(sequenceNumber)")
        sequenceNums.append(sequenceNumber)
        // 检查是否有回包
        DispatchQueue.main.asyncAfter(deadline: .now()+interval) {
            let hasRes = !self.sequenceNums.contains(sequenceNumber)
            if !hasRes {
                logger.log(level: .info, "didn't receive response from \(pinger.hostName)")
            }
            self.pingCallback(hasRes)
            self.stop()
        }
    }
    
    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        logger.info("receive unexpected packet")
    }
    
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        logger.info("receive ping response \(sequenceNumber)")
        if let index = sequenceNums.firstIndex(of: sequenceNumber) {
            sequenceNums.remove(at: index)
        }
    }
    
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        logger.info("fail to send packet \(sequenceNumber) \(error.localizedDescription)")
    }
}
