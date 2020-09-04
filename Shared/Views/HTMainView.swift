//
//  HTMainView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/6/23.
//

import SwiftUI

struct HTMainView: View {
    var body: some View {
        #if !os(macOS)
        HTCardListView()
            .ignoresSafeArea(.all, edges: [.bottom])
        #else
        NavigationView {
            VStack {
                HTCardListView()
                    .padding([.top])
                
                Spacer()
            }
            .fixedSize(horizontal: true, vertical: false)
        }
        .frame(minWidth: 800, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
        #endif
    }
}

#if DEBUG
struct HTMainView_Previews: PreviewProvider {
    static var previews: some View {
        HTMainView()
    }
}
#endif
