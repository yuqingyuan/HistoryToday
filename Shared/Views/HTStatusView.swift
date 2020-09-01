//
//  HTImageStatusView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/8/17.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI

struct HTImageLostView: View {
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
            
            VStack(spacing: 6) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.yellow)
                    .font(.largeTitle)
                Text("没能找到相关图片")
                    .font(.subheadline)
            }
        }
    }
}

struct HTImageLoadingView: View {
    
    @Binding var progress: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .opacity(0.2)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.blue)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
        }
    }
}

struct HTStatusView_Previews: PreviewProvider {
    static var previews: some View {
        HTImageLostView()
    }
}
