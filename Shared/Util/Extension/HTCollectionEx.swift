//
//  HTCollectionEx.swift
//  iOS
//
//  Created by yuqingyuan on 2020/9/1.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import Foundation

extension RandomAccessCollection where Self.Element: Identifiable {
    func isLastItem<Item: Identifiable>(_ item: Item) -> Bool {
        guard !isEmpty else {
            return false
        }
        
        guard let itemIndex = firstIndex(where: { $0.id.hashValue == item.id.hashValue }) else {
            return false
        }
        
        let distance = self.distance(from: itemIndex, to: endIndex)
        return distance == 1
    }
}
