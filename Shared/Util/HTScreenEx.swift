//
//  HTScreenEx.swift
//  iOS
//
//  Created by yuqingyuan on 2020/6/24.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import Foundation
import UIKit

var screenWidth: CGFloat {
    UIScreen.main.bounds.size.width
}

var screenHeight: CGFloat {
    UIScreen.main.bounds.size.height
}

var homeIndicatorHeight: CGFloat {
    if let delegate = UIApplication.shared.delegate, let window = delegate.window {
        return window?.safeAreaInsets.bottom ?? 0
    }
    return 0
}

func scaleW(_ value: CGFloat) -> CGFloat {
    return (screenWidth / 375.0) * value
}

func scaleH(_ value: CGFloat) -> CGFloat {
    return (value / 667.0) * (screenHeight - homeIndicatorHeight)
}
