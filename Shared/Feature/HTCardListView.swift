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
        HTPagedTableView(items: $eventVM.events) { event in
            VStack {
                HTCardView(event: event)
                    .frame(width: screenWidth, height: screenHeight)
            }
        }
        .frame(width: screenWidth, height: screenHeight)
    }
}

struct HTCardListView_Previews: PreviewProvider {
    static var previews: some View {
        HTCardListView()
    }
}
