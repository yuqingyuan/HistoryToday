//
//  HTSettingsView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/9/21.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI

struct HTSettingsView: View {
    @EnvironmentObject var appSetting: HTAppSetting
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $appSetting.source, label: Text("关键词来源")) {
                        ForEach(HTAppSetting.KeywordHost.allCases) { (source: HTAppSetting.KeywordHost) in
                            Text(source.description).tag(source)
                        }
                    }
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
