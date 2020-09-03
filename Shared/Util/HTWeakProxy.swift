//
//  HTWeakProxy.swift
//  iOS
//
//  Created by yuqingyuan on 2020/9/2.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import UIKit

class HTWeakProxy: NSObject {
    
    weak var target: NSObjectProtocol?
    
    init(target: NSObjectProtocol) {
        self.target = target
        super.init()
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        return (target?.responds(to: aSelector) ?? false) || super.responds(to: aSelector)
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return target
    }
}
