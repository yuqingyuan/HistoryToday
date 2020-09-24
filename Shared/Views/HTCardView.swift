//
//  HTCardView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/6/24.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI

struct HTEventKeywordLink: Identifiable {
    var id: String { link }
    var link: String
}

struct HTCardView: View {
    let event: HTEvent
    @State var keyLink: HTEventKeywordLink? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            HTCarouselView(imgURLs: event.imgs)
                .frame(width: screenWidth, height: fitHeight(260))
            
            HStack(spacing: 0) {
                Text(event.displayYear)
                    .font(.custom(ktFont, size: 60))
                Text(event.displayType)
                    .font(.custom(ktFont, size: 30))
                    .padding([.top])
                Spacer()
            }
            .padding([.leading])
            
            HTHyperLinkText(text: event.detail, configuration: event.links) { link in
                keyLink = HTEventKeywordLink(link: link)
                triggerImpact(style: .medium)
            }
            .padding([.leading, .trailing])
            
            Spacer()
        }
        .sheet(item: $keyLink) {
            HTWKWebView(request: URLRequest(url: URL(string: $0.link)!))
        }
    }
}
