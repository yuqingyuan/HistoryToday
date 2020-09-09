//
//  HTCarouselView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/9/3.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor

struct HTCarouselView: View {
    
    let imgURLs: [String]
    
    var body: some View {
        GeometryReader { geo in
            if imgURLs.count == 0 {
                HTImageLostView()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .center, spacing: 0) {
                        ForEach(imgURLs, id: \.self) {
                            HTCardImageView(imgURL: $0)
                                .frame(width: geo.size.width - 40, height: geo.size.height - 40)
                                .shadow(radius: 4)
                                .background(Color.white)
                        }
                        .frame(width: geo.size.width, alignment: .center)
                    }
                }
            }
        }
    }
}

struct HTCardImageView: View {
    
    let imgURL: String
    
    var body: some View {
        GeometryReader { geo in
            #if !os(macOS)
            KFImage(URL(string: imgURL),
                    options: [
                        .processor(
                            DownsamplingImageProcessor(size: .init(width: geo.size.width, height: geo.size.height))
                        )
                    ])
                .placeholder {
                    ProgressView()
                }
                .cancelOnDisappear(true)
                .resizable()
                .cornerRadius(10)
            #else
            KFImage(URL(string: imgURL))
                .cancelOnDisappear(true)
                .resizable()
                .cornerRadius(10)
            #endif
        }
    }
}
