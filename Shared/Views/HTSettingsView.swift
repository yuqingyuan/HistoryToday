//
//  HTSettingsView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/9/21.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI

struct HTSettingsView: View {
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: .constant(1), label: Text("关键词来源")) {
                        Text("维基百科").tag(1)
                        Text("百度百科").tag(2)
                    }
                }
                
                Section(header: Text("通用")) {
                    Toggle("深色模式", isOn: .constant(false))
                    
                    Toggle("主题模式跟随系统外观", isOn: .constant(false))
                }
                
                Section(header: Text("存储空间"), footer: Text("可清理本地图片等数据")) {
                    Button("清除缓存") {
                        
                    }
                }
                
                Section {
                    NavigationLink(destination: Text("关于")) {
                        Text("关于")
                    }
                }
            }
            .navigationTitle(Text("设置"))
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
