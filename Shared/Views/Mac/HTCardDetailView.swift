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
    let gridItems = [GridItem(.adaptive(minimum: 200, maximum: 200), spacing: 16, alignment: .top)]
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
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
                    VStack(alignment: .leading) {
                        HStack {
                            Text("相关图片")
                                .font(.custom(ktFont, size: 26)).bold()
                                .foregroundColor(.secondary)
                            
                            Image(systemName: "photo.on.rectangle.angled")
                            
                            Spacer()
                        }
                        
                        LazyVGrid(columns: gridItems, alignment: .leading, spacing: 16) {
                            ForEach(event.imgs, id: \.self) { url in
                                HTCardImageView(imgURL: url)
                                    .aspectRatio(1, contentMode: .fit)
                            }
                        }
                    }
                    .padding()
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("相关链接")
                            .font(.custom(ktFont, size: 26)).bold()
                            .foregroundColor(.secondary)
                        
                        Image(systemName: "link")
                        
                        Spacer()
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
    }
}

#if DEBUG
struct HTCardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HTCardDetailView(event: preview_event)
            .frame(minWidth: 800, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
    }
}
#endif
