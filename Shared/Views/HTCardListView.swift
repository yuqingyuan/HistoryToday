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
            
            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(eventVM.events) { event in
                            #if !os(macOS)
                            HTCardView(event: event)
                                .frame(width: geo.size.width, height: geo.size.height)
                                .onAppear {
                                    if eventVM.events.isLastItem(event) {
                                        eventVM.loadMoreData()
                                    }
                                }
                            #else
                            HTBriefEventView(event: .constant(event))
                                .frame(height: 100)
                                .padding()
                                .onAppear {
                                    if eventVM.events.isLastItem(event) {
                                        eventVM.loadMoreData()
                                    }
                                }
                            #endif
                        }
                    }
                }
            }
        }
    }
}

struct HTCardListHeaderView: View {
    
    @Binding var eventVM: HTEventViewModel
    
    var body: some View {
        HStack {
            VStack {
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
                .fixedSize()
            }
            .padding([.top])
            
            #if !os(macOS)
            if eventVM.isLoading {
                ProgressView()
                    .padding([.top, .leading])
            }
            
            Spacer()
            #endif
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(eventVM.month)月\(eventVM.day)日")
                    .font(.custom(ktFont, size: 20))
                Text("历史上的今天")
                    .font(.custom(ktFont, size: 30))
            }
        }
    }
}

#if os(macOS)
struct HTBriefEventView: View {
    
    @Binding var event: HTEvent
    
    var body: some View {
        HStack {
            HTCardImageView(imgURL: event.imgs.first ?? "")
                .frame(width: 100, height: 100)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 0) {
                    Text(event.displayYear)
                    Text(event.displayType)
                }
                
                Text(event.detail)
                
                Spacer()
            }
            .font(.custom(ktFont, size: 16))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.blue)
        }
    }
}
#endif

#if DEBUG
struct HTCardListView_Previews: PreviewProvider {
    static var previews: some View {
        HTCardListView(eventVM: HTEventViewModel(type: .normal))
            .ignoresSafeArea(.all, edges: [.bottom])
    }
}
#endif
