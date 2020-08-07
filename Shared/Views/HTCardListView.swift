//
//  HTCardView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/6/24.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI

struct HTCardListView: View {

    @ObservedObject var eventVM = HTEventViewModel()
    @State var presentSideMenu = false
    
    var body: some View {
        HTPagedCollectionView(items: $eventVM.events, direction: .vertical) { event, index in
            VStack {
                HStack {
                    Text("July")
                        .font(.largeTitle)

                    Spacer()

                    Button(action: {
                        withAnimation {
                            presentSideMenu.toggle()
                        }
                    }) {
                        Image(systemName: "sidebar.left")
                    }
                }
                .padding([.leading, .top, .trailing])

                HTCardView(event: event)
            }
        }
        .ignoresSafeArea(.container, edges: [.bottom])
    }
}

#if DEBUG
struct HTCardListView_Previews: PreviewProvider {
    static var previews: some View {
        HTCardListView(eventVM: preview_eventVM)
    }
}
#endif
