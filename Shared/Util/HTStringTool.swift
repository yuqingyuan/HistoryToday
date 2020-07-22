//
//  HTStringTool.swift
//  iOS
//
//  Created by yuqingyuan on 2020/7/1.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import Foundation

extension String {
    
    func toDateWithFormat(_ format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
