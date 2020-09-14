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
                        ForEach(imgURLs, id: \.self) { url in
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 4)
                                    
                                HTCardImageView(imgURL: url)
                            }
                            .frame(width: geo.size.width - 40, height: geo.size.height - 40)
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
    
    @State var failure = false
    let clipShape = RoundedRectangle(cornerRadius: 10, style: .continuous)
    
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
                    if !failure {
                        ProgressView()
                    } else {
                        Image(systemName: "bandage")
                    }
                }
                .onFailure { _ in
                    failure = true
                }
                .cancelOnDisappear(true)
                .resizable()
                .cornerRadius(10)
            #else
            KFImage(URL(string: imgURL))
                .placeholder {
                    if !failure {
                        Image(systemName: "rays")
                    } else {
                        Image(systemName: "bandage")
                    }
                }
                .onFailure { _ in
                    failure = true
                }
                .cancelOnDisappear(true)
                .resizable()
                .background(Color(.textBackgroundColor))
                .clipShape(clipShape)
                .overlay(
                    clipShape
                        .inset(by: 0.5)
                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                )
            #endif
        }
    }
}
