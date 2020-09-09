//
//  HTMainView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/6/23.
//

import SwiftUI

struct HTMainView: View {
    
    @StateObject var eventVM: HTEventViewModel
    #if os(macOS)
    @State private var selection: Set<EventType> = [.normal]
    #endif
    
    var body: some View {
        #if !os(macOS)
        VStack(spacing: 0) {
            VStack {
                HTCardListHeader(eventVM: eventVM)
                Divider()
            }
            .padding([.leading, .trailing])
            
            HTCardListView(eventVM: eventVM)
                .ignoresSafeArea(.all, edges: [.bottom])
        }
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
            
            Text("")
            
            Text("")
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
