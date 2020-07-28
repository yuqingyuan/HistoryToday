//
//  HTScreenEx.swift
//  iOS
//
//  Created by yuqingyuan on 2020/6/24.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import Foundation
#if !os(macOS)
import UIKit
#else
import AppKit
#endif

var screenWidth: CGFloat {
    #if !os(macOS)
    return UIScreen.main.bounds.size.width
    #else
    return NSScreen.main!.frame.size.width
    #endif
}

var screenHeight: CGFloat {
    #if !os(macOS)
    return UIScreen.main.bounds.size.height
    #else
    return NSScreen.main!.frame.size.height
    #endif
}

#if !os(macOS)
var homeIndicatorHeight: CGFloat {
    if let delegate = UIApplication.shared.delegate, let window = delegate.window {
        return window?.safeAreaInsets.bottom ?? 0
    }
    return 0
}
#endif
