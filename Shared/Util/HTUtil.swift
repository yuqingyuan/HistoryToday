//
//  HTUtil.swift
//  iOS
//
//  Created by yuqingyuan on 2020/6/24.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import Foundation
import SwiftUI
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

var commonFontName = "FZKai-Z03S"

func rgb(_ r: Double, _ g: Double, _ b: Double) -> Color {
    return Color(red: r/255.0, green: g/255.0, blue: b/255.0)
}
