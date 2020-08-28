//
//  HTWKWebView.swift
//  HistoryToday
//
//  Created by yuqingyuan on 2020/8/7.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI
import WebKit

struct HTWKWebView: UIViewRepresentable {
    
    let request: URLRequest
        
    func makeUIView(context: Context) -> WKWebView  {
        let wkView = WKWebView()
        wkView.scrollView.isPagingEnabled = false
        return wkView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}
