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
        VStack(spacing: 0) {
            HTCarouselView(imgURLs: event.imgs)
                .frame(width: screenWidth, height: fitHeight(260))
            
            HStack(spacing: 0) {
                Text(event.displayYear)
                    .font(.custom(commonFontName, size: 60))
                Text(event.displayType)
                    .font(.custom(commonFontName, size: 30))
                    .padding([.top])
                Spacer()
            }
            .padding([.leading])
            
            HTHyperLinkText(text: event.detail, configuration: event.links) { _, keyword in
                keyLink = HTEventKeywordLink(link: "https://baike.baidu.com/item/"+keyword)
            }
            .padding([.leading, .trailing])
            
            Spacer()
        }
        .sheet(item: $keyLink) {
            HTWKWebView(request: URLRequest(url: URL(string: $0.link.urlEncoded())!))
        }
    }
}

struct HTCarouselView: View {
    
    let imgURLs: [String]
    @State var progress: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geo in
            if imgURLs.count == 0 {
                HTImageLostView()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .center, spacing: 0) {
                        ForEach(imgURLs, id: \.self) {
                            KFImage(URL(string: $0),
                                    options: [
                                        .processor(
                                            DownsamplingImageProcessor(size: .init(width: geo.size.width - 40, height: geo.size.height - 40))
                                        )
                                    ])
                                .placeholder {
                                    HTImageLoadingView(progress: $progress)
                                        .frame(width: 40, height: 40)
                                }
                                .onProgress { progress = CGFloat($0)/CGFloat($1) }
                                .cancelOnDisappear(true)
                                .resizable()
                                .frame(width: geo.size.width - 40, height: geo.size.height - 40)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 4)
                        }
                        .frame(width: screenWidth, alignment: .center)
                    }
                }
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
