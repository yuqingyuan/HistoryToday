//
//  HTCardView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/6/24.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI

struct HTCardView: View {
    
    @ObservedObject var eventVM = HTEventViewModel()
    
    var body: some View {
        ZStack {
            List(eventVM.events, id: \.id) {
                Text($0.detail)
            }
            
            Button("更多内容") {
                eventVM.loadMoreData()
            }
        }
    }
}

struct HTCardView_Previews: PreviewProvider {
    static var previews: some View {
        HTCardView()
    }
}
