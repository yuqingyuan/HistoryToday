//
//  HistoryTodayApp.swift
//  Shared
//
//  Created by yuqingyuan on 2020/6/23.
//

import SwiftUI

@main
struct HTApp: App {
    @StateObject var appSetting = HTAppSetting.shared

    init() {
        #if !os(macOS)
        UIScrollView.appearance().isPagingEnabled = true
        #endif
    }

    var body: some Scene {
        WindowGroup {
            HTMainView(eventVM: .init(type: .normal))
                .onAppear {
                    appSetting.loadSetting()
                }
                .environmentObject(appSetting)
        }
    }
}
