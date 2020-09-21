//
//  HTCardDetailView.swift
//  macOS
//
//  Created by yuqingyuan on 2020/9/8.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI

struct HTCardDetailView: View {
    
    @StateObject var event: HTEvent
    let clipShape = RoundedRectangle(cornerRadius: 20, style: .continuous)
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 30) {
                        HStack(spacing: 0) {
                            Text(event.displayYear)
                            Text(event.displayType)
                        }
                        .font(.custom(ktFont, size: 55))

                        Text(event.detail)
                            .font(.custom(ktFont, size: 35))

                        Spacer()
                    }
                    .frame(width: proxy.size.width - 100, height: 250, alignment: .leading)
                    .padding()
                    .background(Color(.textBackgroundColor))
                    .clipShape(clipShape)
                    .overlay(
                        clipShape
                            .inset(by: 0.5)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    )
                    
                    if event.imgs.count != 0 {
                        HTImageGridView(imgs: .constant(event.imgs))
                    }
                    
                    HTKeywordLinkView(event: .constant(event))
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct HTImageGridView: View {
    
    @Binding var imgs: [String]
    let gridItems = [GridItem(.adaptive(minimum: 200, maximum: 200), spacing: 16, alignment: .top)]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("相关图片")
                    .font(.custom(ktFont, size: 26)).bold()
                    .foregroundColor(.secondary)
                
                Image(systemName: "photo.on.rectangle.angled")
                
                Spacer()
            }
            
            LazyVGrid(columns: gridItems, alignment: .leading, spacing: 16) {
                ForEach(imgs, id: \.self) { url in
                    HTCardImageView(imgURL: url)
                        .aspectRatio(1, contentMode: .fit)
                }
            }
        }
    }
}

struct HTKeywordLinkView: View {
    
    @Binding var event: HTEvent
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("相关链接")
                    .font(.custom(ktFont, size: 26))
                    .bold()
                    .foregroundColor(.secondary)
                
                Image(systemName: "link")
                
                Spacer()
            }
        }
    }
}

#if DEBUG
struct HTCardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HTKeywordLinkView(event: .constant(preview_event))
            HTImageGridView(imgs: .constant(preview_event.imgs))
            HTCardDetailView(event: preview_event)
                .frame(minWidth: 800, maxWidth: .infinity, minHeight: 800, maxHeight: .infinity)
        }
    }
}
#endif
