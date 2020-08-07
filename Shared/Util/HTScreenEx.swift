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

var statusBarHeight: CGFloat {
    UIApplication.shared.windows
        .filter { $0.isKeyWindow }
        .first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
}

func fitWidth(_ width: CGFloat) -> CGFloat {
    return width*(screenWidth/375.0)
}

func fitHeight(_ height: CGFloat) -> CGFloat {
    return height*(screenHeight/667.0)
}

func fitFont(_ font: CGFloat) -> CGFloat {
    return fitHeight(font)
}
#endif
