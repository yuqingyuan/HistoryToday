//
//  HTStringEx.swift
//  HistoryToday
//
//  Created by yuqingyuan on 2020/8/7.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import Foundation

extension String {
    
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
     
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}
