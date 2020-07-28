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
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(eventVM.events, id: \.self) { event in
                    VStack {
                        HTCardView(event: .constant(event))
                            .frame(height: 450, alignment: .center)
                            .padding([.leading, .trailing], 10)
                    }
                    .frame(width: screenWidth, height: screenHeight)
                }
            }
        }
    }
}

struct HTCardListView_Previews: PreviewProvider {
    static var previews: some View {
        HTCardListView()
    }
}
