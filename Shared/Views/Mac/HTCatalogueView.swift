//
//  HTCatalogueList.swift
//  HistoryToday
//
//  Created by yuqingyuan on 2020/9/7.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI

struct HTCatalogueView: View {

    @StateObject var event: HTEvent

    var body: some View {
        HStack {
            HTCardImageView(imgURL: event.imgs.first ?? "")
                .frame(width: 100, height: 100)
                .background(Color.clear)

            VStack(alignment: .leading, spacing: 10) {
                Text(event.displayYear+"年")
                    .font(.custom(ktFont, size: 18))

                Text(event.keywords)
                    .font(.custom(ktFont, size: 16))

                Spacer()
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.blue)
        }
    }
}

#if DEBUG
struct HTCatalogueList_Previews: PreviewProvider {
    static var previews: some View {
        HTCatalogueView(event: preview_event)
            .fixedSize()
            .padding()
    }
}
#endif
