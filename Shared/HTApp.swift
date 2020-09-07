//
//  HistoryTodayApp.swift
//  Shared
//
//  Created by yuqingyuan on 2020/6/23.
//

import SwiftUI

@main
struct HTApp: App {
    
    init() {
        #if !os(macOS)
        UIScrollView.appearance().isPagingEnabled = true
        #endif
        HTAppSetting.shared.loadSetting()
    }
    
    var body: some Scene {
        WindowGroup {
            HTMainView(eventVM: .init(type: .normal))
        }
    }
}
