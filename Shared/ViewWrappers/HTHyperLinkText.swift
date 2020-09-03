//
//  HTHightLightText.swift
//  iOS
//
//  Created by yuqingyuan on 2020/8/3.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI

struct HTHyperLinkText: UIViewRepresentable {
    
    let text: String
    let configuration: Dictionary<String, String>?
    let onTap: (String) -> ()
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.backgroundColor = .clear
        textView.hyperLinks(original: text, hypers: configuration)
        textView.sizeToFit()
        textView.isEditable = false
        textView.isSelectable = true
        textView.delegate = context.coordinator
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        DispatchQueue.main.async {
            uiView.hyperLinks(original: text, hypers: configuration)
            uiView.sizeToFit()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self.onTap)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        let onTap: (String) -> ()
        
        init(_ onTap: @escaping (String) -> ()) {
            self.onTap = onTap
        }
        
        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            let range = Range(characterRange, in: textView.text)
            let link: String
            if HTAppSetting.shared.source == .wiki {
                link = "https://zh.wikipedia.org" + URL.absoluteString
            } else {
                link = "https://baike.baidu.com/item/" + String(textView.text[range!]).urlEncoded()
            }
            self.onTap(link)
            return false
        }
    }
}

extension UITextView {
    func hyperLinks(original: String, hypers: [String: String]?) {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        let attributedText = NSMutableAttributedString(string: original)
        let fullRange = NSRange(location: 0, length: attributedText.length)
        for (hyper, link) in hypers ?? [:] {
            let linkRange = attributedText.mutableString.range(of: hyper)
            attributedText.addAttribute(.link, value: link, range: linkRange)
        }
        self.linkTextAttributes = [
            .foregroundColor: UIColor(rgb(235,87,87))
        ]
        attributedText.addAttribute(.paragraphStyle, value: style, range: fullRange)
        attributedText.addAttribute(.font, value: UIFont(name: ktFont, size: fitFont(18))!, range: fullRange)
        attributedText.addAttribute(.foregroundColor, value: UIColor(named: "mainTextColor")!, range: fullRange)
        self.attributedText = attributedText
    }
}
