//
//  HTMainView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/6/23.
//

import SwiftUI

struct HTMainView: View {
    
    @StateObject var eventVM: HTEventViewModel
    @State var showSetting = false
    #if os(macOS)
    @State private var selection: Set<EventType> = [.normal]
    #endif
    
    private var settingButton: some View {
        Button {
            showSetting.toggle()
        } label: {
            Image(systemName: "gearshape.2")
                .padding()
                .background(
                    Circle()
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                )
        }
        .sheet(isPresented: $showSetting) {
            HTSettingsView()
        }
    }
    
    var body: some View {
        #if !os(macOS)
        VStack(spacing: 0) {
            VStack {
                HTCardListHeader(eventVM: eventVM)
                    .padding([.leading, .trailing])
                
                Divider()
            }
            .background(Color("mainHeaderColor").ignoresSafeArea())
            
            HTCardListView(eventVM: eventVM)
                .ignoresSafeArea(.all, edges: [.bottom])
        }
        .overlay(settingButton.padding(), alignment: .bottomTrailing)
        .background(Color("mainViewColor").ignoresSafeArea())
        #else
        NavigationView {
            List(selection: $selection) {
                ForEach(EventType.allCases) { type in
                    NavigationLink(destination: HTCardListView(eventVM: .init(type: type))) {
                        Label(type.description.title, systemImage: type.description.img)
                    }
                    .tag(type)
                }
            }
            .listStyle(SidebarListStyle())
            
            Text("选择事件类型")
            
            Text("选择事件")
        }
        .frame(minWidth: 800, idealWidth: 800, maxWidth: .infinity, minHeight: 600, idealHeight: 600, maxHeight: .infinity)
        #endif
    }
}

#if DEBUG
struct HTMainView_Previews: PreviewProvider {
    static var previews: some View {
        HTMainView(eventVM: .init(type: .normal))
    }
}
#endif
