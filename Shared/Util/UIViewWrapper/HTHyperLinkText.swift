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
        textView.hyperLinks(original: text, hypers: configuration)
        textView.sizeToFit()
        textView.isEditable = false
        textView.isSelectable = true
        textView.delegate = context.coordinator
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
            self.onTap(URL.absoluteString)
            return false
        }
    }
}

extension UITextView {
    func hyperLinks(original: String, hypers: [String: String]?) {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        let attributedText = NSMutableAttributedString(string: original)
        if let hypers = hypers {
            for (hyper, link) in hypers {
                let linkRange = attributedText.mutableString.range(of: hyper)
                let fullRange = NSRange(location: 0, length: attributedText.length)
                attributedText.addAttribute(.link, value: link, range: linkRange)
                attributedText.addAttribute(.paragraphStyle, value: style, range: fullRange)
                attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 20), range: fullRange)
            }
            self.linkTextAttributes = [
                .foregroundColor: UIColor.blue
            ]
        }
        self.attributedText = attributedText
    }
}
