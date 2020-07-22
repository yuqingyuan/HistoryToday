//
//  HTDateTool.swift
//  HistoryToday
//
//  Created by yuqingyuan on 2020/7/1.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import Foundation

extension Date {
    
    var year: Int? {
        components().year
    }
    
    var month: Int? {
        components().month
    }
    
    var day: Int? {
        components().day
    }
    
    private func components() -> DateComponents {
        Calendar.current.dateComponents([.year, .month, .day], from: self)
    }
}
