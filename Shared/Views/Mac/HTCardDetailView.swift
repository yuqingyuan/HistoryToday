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
    let gridItems = [GridItem(.adaptive(minimum: 130), spacing: 16, alignment: .top)]
    
    var body: some View {
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
            .frame(height: 250)
            .padding()
            .background(Color(.textBackgroundColor))
            .clipShape(clipShape)
            .overlay(
                clipShape
                    .inset(by: 0.5)
                    .stroke(Color.primary.opacity(0.1), lineWidth: 1)
            )
            
            VStack(alignment: .leading) {
                HStack {
                    Text("相关图片")
                        .font(.custom(ktFont, size: 26)).bold()
                        .foregroundColor(.secondary)
                    
                    Image(systemName: "photo.on.rectangle.angled")
                }
                
                LazyVGrid(columns: gridItems, alignment: .center, spacing: 16) {
                    ForEach(event.imgs, id: \.self) {
                        HTCardImageView(imgURL: $0)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
}

#if DEBUG
struct HTCardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HTCardDetailView(event: preview_event)
        }
        .frame(width: 800, height: 600)
    }
}
#endif
