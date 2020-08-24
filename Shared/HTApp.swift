//
//  HistoryTodayApp.swift
//  Shared
//
//  Created by yuqingyuan on 2020/6/23.
//

import SwiftUI

@main
struct HTApp: App {
    var body: some Scene {
        WindowGroup {
            #if !os(macOS)
            HTMainView()
            #else
            Text("Hello")
            #endif
        }
    }
}

struct HTApp_Previews: PreviewProvider {
    static var previews: some View {
        #if !os(macOS)
        HTMainView()
        #endif
    }
}
