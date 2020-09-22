//
//  HTAppSetting.swift
//  iOS
//
//  Created by yuqingyuan on 2020/9/2.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import Foundation
import Kingfisher
import os

fileprivate let logger = Logger(subsystem: "com.qingyuanyu.HistoryToday", category: "AppSetting")

class HTAppSetting: ObservableObject {
    static let shared = HTAppSetting()
    
    enum KeywordHost: String, CaseIterable, Identifiable, CustomStringConvertible {
        case baidu = "baike.baidu.com"
        case wiki  = "zh.wikipedia.org"
        
        var id: String {
            return self.rawValue
        }
        
        var description: String {
            if self == .baidu {
                return "百度百科"
            }
            return "维基百科"
        }
    }
    
    private var pingTool: HTHostPingTool?
    
    /// 关键词来源
    @Published var source: KeywordHost = .baidu
    /// 磁盘缓存大小
    @Published var diskCache: String = "0.0 MB"
    /// 是否正在计算磁盘缓存大小
    @Published var isLoadingCache: Bool = false
}

extension HTAppSetting {
    func loadSetting() {
        pingTool = HTHostPingTool(host: KeywordHost.wiki.rawValue, timeout: 1.5) { [weak self] receive in
            if receive {
                self?.source = .wiki
            }
        }
        pingTool?.start()
    }
    
    func loadDiskCacheStorage() {
        isLoadingCache = true
        ImageCache.default.calculateDiskStorageSize { [weak self] result in
            switch result {
            case .success(let size):
                self?.diskCache = String(format: "%.2f MB", Double(size)/1024/1024)
            case .failure(let error):
                logger.error("\(error.localizedDescription)")
            }
            self?.isLoadingCache = false
        }
    }
    
    func cleanDiskCache() {
        isLoadingCache = true
        ImageCache.default.clearDiskCache { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self?.loadDiskCacheStorage()
            }
        }
    }
}
