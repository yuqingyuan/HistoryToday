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
    
    var body: some View {
        VStack {
            HTCardListHeaderView(date: "\(eventVM.month)月\(eventVM.day)日 ")
                .padding([.leading, .trailing])
            
            HTPagedCollectionView(items: $eventVM.events, direction: .vertical) { event in
                HTCardView(event: event)
            } willDisplay: { index in
                if index == eventVM.events.count - 1 {
                    eventVM.loadMoreData()
                }
            }
            .ignoresSafeArea(.container, edges: [.bottom])
        }
    }
}

struct HTCardListHeaderView: View {
    
    var date: String
    
    var body: some View {
        HStack {
            Button(action: {
                
            }, label: {
                Image(systemName: "books.vertical")
                    .font(Font.system(.title).weight(.light))
            })
            .padding([.top])
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(date)
                    .font(.custom(commonFontName, size: 20))
                Text("历史上的今天")
                    .font(.custom(commonFontName, size: 30))
            }
        }
    }
}

#if DEBUG
struct HTCardListView_Previews: PreviewProvider {
    static var previews: some View {
        HTCardListView(eventVM: preview_eventVM)
    }
}
#endif
