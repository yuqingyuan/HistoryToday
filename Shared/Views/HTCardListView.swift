//
//  HTCardView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/6/24.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI

struct HTCardListView: View {

    @StateObject var eventVM: HTEventViewModel
    
    var body: some View {
        #if !os(macOS)
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(eventVM.events) { event in
                        HTCardView(event: event)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .onAppear {
                                if eventVM.events.isLastItem(event) {
                                    eventVM.loadMoreData()
                                }
                            }
                    }
                }
            }
        }
        #else
        List {
            ForEach(eventVM.events) { event in
                NavigationLink(
                    destination: Text("Destination"),
                    label: {
                        HTCatalogueView(event: event)
                            .frame(minWidth: 300, maxWidth: 300)
                            .padding([.top, .bottom, .trailing])
                            .onAppear {
                                if eventVM.events.isLastItem(event) {
                                    eventVM.loadMoreData()
                                }
                            }
                    })
            }
        }
        #endif
    }
}

#if DEBUG
struct HTCardListView_Previews: PreviewProvider {
    static var previews: some View {
        HTCardListView(eventVM: HTEventViewModel(type: .normal))
            .ignoresSafeArea(.all, edges: [.bottom])
    }
}
#endif
