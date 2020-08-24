//
//  HTCardView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/6/24.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI

struct HTCardListView: View {

    @ObservedObject var eventVM = HTEventViewModel(type: .normal)
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HTCardListHeaderView(eventVM: .constant(eventVM))

                Divider()
            }
            .padding([.leading, .trailing])
            
            HTPagedCollectionView(items: $eventVM.events, direction: .vertical) {
                HTCardView(event: $0)
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
    
    @Binding var eventVM: HTEventViewModel
    
    var body: some View {
        HStack {
            HStack(spacing: 10) {
                Menu {
                    Button {
                        eventVM.type = .normal
                    } label: {
                        Text("历史")
                        Image(systemName: "text.book.closed")
                    }
                    Button {
                        eventVM.type = .birth
                    } label: {
                        Text("出生")
                        Image(systemName: "sunrise")
                    }
                    Button {
                        eventVM.type = .death
                    } label: {
                        Text("逝世")
                        Image(systemName: "sunset")
                    }
                } label: {
                    Image(systemName: "books.vertical")
                        .font(Font.system(.title).weight(.light))
                }
                
                if eventVM.isLoading {
                    ProgressView()
                }
                
                #if DEBUG
                    HTFPSLabel()
                        .frame(width: 55, height: 20)
                #endif
            }
            .padding([.top])
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(eventVM.month)月\(eventVM.day)日 ")
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
        HTCardListView(eventVM: HTEventViewModel(type: .normal))
    }
}
#endif
