//
//  HTAppSetting.swift
//  iOS
//
//  Created by yuqingyuan on 2020/9/2.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import Foundation

enum HTKeywordSource: String {
    case baidu = "baike.baidu.com"
    case wiki  = "zh.wikipedia.org"
}

class HTAppSetting {
    static let shared = HTAppSetting()
    
    private var pingTool: HTHostPingTool?
    var source: HTKeywordSource = .baidu
    
    func loadSetting() {
        pingTool = HTHostPingTool(host: HTKeywordSource.wiki.rawValue, timeout: 0.5) { [weak self] receive in
            if receive {
                self?.source = .wiki
            }
        }
        pingTool?.start()
    }
}
