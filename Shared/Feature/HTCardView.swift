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

struct HTCardView: View {
    let event: HTEvent
    
    var body: some View {
        VStack {
            Spacer(minLength: statusBarHeight)
            
            HStack {
                Text("July")
                    .font(.largeTitle)
                Spacer()
            }
            .padding([.leading, .top])
            
            HTCarouselView(imgURLs: event.imgs)
                .frame(width: screenWidth, height: fitHeight(260))
            
            HTHyperLinkText(text: event.detail, configuration: event.links) { _ in
                
            }
            .padding()
        }
    }
}

struct HTCarouselView: View {
    
    let imgURLs: [String]
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(imgURLs, id: \.self) {
                        KFImage(URL(string: $0),
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
                .padding()
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
