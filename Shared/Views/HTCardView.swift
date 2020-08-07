//
//  HTCardView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/6/24.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor

struct HTEventKeywordLink: Identifiable {
    var id: String { link }
    var link: String
}

struct HTCardView: View {
    let event: HTEvent
    @State var keyLink: HTEventKeywordLink?
    
    var body: some View {
        VStack {
            HTCarouselView(imgURLs: event.imgs)
                .frame(width: screenWidth, height: fitHeight(260))
            
            HTHyperLinkText(text: event.detail, configuration: event.links) { _, keyword in
                keyLink = HTEventKeywordLink(link: "https://baike.baidu.com/item/"+keyword)
            }
            .padding([.leading, .trailing])
        }
        .sheet(item: $keyLink) {
            HTWKWebView(request: URLRequest(url: URL(string: $0.link.urlEncoded())!))
        }
    }
}

struct HTCarouselView: View {
    
    let imgURLs: [String]
    
    var body: some View {
        GeometryReader { geo in
            HTPagedCollectionView(items: .constant(imgURLs)) { url, _ in
                KFImage(URL(string: url),
                        options: [
                            .processor(
                                DownsamplingImageProcessor(size: CGSize(width: geo.size.width - 40,
                                                                        height: geo.size.height - 40))
                            )
                        ])
                    .cancelOnDisappear(true)
                    .resizable()
                    .frame(width: geo.size.width - 40, height: geo.size.height - 40)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 4)
            }
        }
    }
}

#if DEBUG
struct HTCardView_Preview: PreviewProvider {
    static var previews: some View {
        HTCardView(event: preview_event)
    }
}
#endif
