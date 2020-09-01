//
//  HTMainView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/6/23.
//

import SwiftUI

struct HTMainView: View {
    var body: some View {
        HTCardListView()
            .ignoresSafeArea(.all, edges: [.bottom])
    }
}

#if DEBUG
struct HTMainView_Previews: PreviewProvider {
    static var previews: some View {
        HTMainView()
    }
}
#endif
