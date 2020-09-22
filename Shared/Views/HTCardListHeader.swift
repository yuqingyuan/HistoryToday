//
//  HTCardListHeader.swift
//  HistoryToday
//
//  Created by yuqingyuan on 2020/9/7.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI

struct HTCardListHeader: View {
    
    @StateObject var eventVM: HTEventViewModel
    
    var body: some View {
        HStack {
            VStack {
                Menu {
                    ForEach(EventType.allCases) { type in
                        Button {
                            eventVM.type = type
                        } label: {
                            Text(type.description.title)
                            Image(systemName: type.description.img)
                        }
                    }
                } label: {
                    Image(systemName: "books.vertical")
                        .font(Font.system(.title).weight(.light))
                }
            }
            .padding([.top])
            
            if eventVM.isLoading {
                ProgressView()
                    .padding([.top, .leading])
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(eventVM.month)月\(eventVM.day)日")
                    .font(.custom(ktFont, size: 20))
                Text("历史上的今天")
                    .font(.custom(ktFont, size: 30))
            }
        }
    }
}

#if DEBUG
struct HTCardListHeader_Previews: PreviewProvider {
    static var previews: some View {
        HTCardListHeader(eventVM: HTEventViewModel(type: .normal))
            .padding()
            .background(Color(.systemGray5).ignoresSafeArea())
    }
}
#endif
