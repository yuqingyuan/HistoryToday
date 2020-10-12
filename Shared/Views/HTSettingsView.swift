//
//  HTSettingsView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/9/21.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI

struct HTSettingsView: View {
    @StateObject var appSetting = HTAppSetting.shared
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("关键词来源与您当前的网络环境有关")) {
                    Picker(selection: $appSetting.source, label: Text("关键词来源")) {
                        ForEach(HTAppSetting.KeywordHost.allCases) { (source: HTAppSetting.KeywordHost) in
                            if appSetting.isPinging {
                                HStack(spacing: 4) {
                                    ProgressView()
                                    Text(source.description)
                                }
                                .tag(source)
                            } else {
                                Text(source.description)
                                    .tag(source)
                            }
                        }
                    }
                    .onChange(of: appSetting.source) {
                        if $0 == .wiki {
                            appSetting.startPing()
                        }
                    }
                    .disabled(appSetting.isPinging)
                }
                
                Section {
                    HStack {
                        Button("清除缓存") {
                            appSetting.cleanDiskCache()
                        }
                        .disabled(appSetting.isLoadingCache)
                        
                        Spacer()
                        
                        if appSetting.isLoadingCache {
                            ProgressView()
                        } else {
                            Text(appSetting.diskCache)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: HTAboutView()) {
                        Text("关于")
                    }
                }
            }
            .navigationTitle(Text("设置"))
        }
        .onAppear {
            appSetting.loadDiskCacheStorage()
        }
    }
}

#if DEBUG
struct HTSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        HTSettingsView()
    }
}
#endif
