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

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 0) {
                    Text(event.displayYear+"年")
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

struct HTCatalogueList_Previews: PreviewProvider {
    static var previews: some View {
        HTCatalogueView(event: preview_event)
            .fixedSize()
            .padding()
    }
}
