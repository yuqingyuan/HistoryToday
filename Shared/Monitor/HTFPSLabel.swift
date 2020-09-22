//
//  FPSLabel.swift
//  Recall
//
//  Created by yuqingyuan on 2020/5/27.
//  Copyright © 2020 俞清源. All rights reserved.
//

#if DEBUG
import UIKit
import SwiftUI

fileprivate class FPSLabel: UILabel {
    
    static let shared = FPSLabel(frame: .init(x: screenWidth - 60, y: 88, width: 55, height: 20))
    
    var displayLink: CADisplayLink!
    var count: Int = 0
    var lastTime: TimeInterval = 0
    var _font: UIFont!
    var _subFont: UIFont!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.textAlignment = .center
        self.isUserInteractionEnabled = true
        self.backgroundColor = .lightGray
        
        _font = UIFont(name: "Menlo", size: 14)
        if _font != nil {
            _subFont = UIFont(name: "Menlo", size: 4)
        } else {
            _font = UIFont(name: "Courier", size: 14)
            _subFont = UIFont(name: "Courier", size: 4)
        }
        
        displayLink = CADisplayLink(target: HTWeakProxy(target: self), selector: #selector(FPSLabel.tick(_:)))
        displayLink.add(to: .main, forMode: .common)
    }

    @objc func tick(_ link: CADisplayLink) {
        guard lastTime != 0 else {
            lastTime = link.timestamp
            return
        }
        
        count += 1
        let passedTime = link.timestamp - lastTime
        guard passedTime >= 1.0 else {
            return
        }
        lastTime = link.timestamp
        let fps = Double(count) / passedTime
        count = 0
        
        let progress = fps / 60.0
        let color = UIColor(hue: CGFloat(0.27 * (progress - 0.2)), saturation: 1, brightness: 0.9, alpha: 1)

        let text = NSMutableAttributedString(string: "\(Int(round(fps))) FPS")
        text.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: text.length - 3))
        text.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: text.length - 3, length: 3))
        text.addAttribute(.font, value: _font!, range: NSRange(location: 0, length: text.length))
        text.addAttribute(.font, value: _subFont!, range: NSRange(location: text.length - 4, length: 1))
        self.attributedText = text
    }
    
    deinit {
        displayLink.invalidate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct HTFPSLabel: UIViewRepresentable {

    func makeUIView(context: Context) -> UILabel {
        return FPSLabel.shared
    }

    func updateUIView(_ uiView: UILabel, context: Context) {

    }
}
#endif
