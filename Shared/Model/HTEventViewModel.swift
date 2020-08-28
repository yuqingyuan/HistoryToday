//
//  HTEventViewModel.swift
//  iOS
//
//  Created by yuqingyuan on 2020/7/20.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import Foundation
import Combine

class HTEventViewModel: ObservableObject {
    
    @Published var events = [HTEvent]()
    @Published var hasMore: Bool = true
    @Published var isLoading: Bool = false
    var month: Int
    var day: Int
    var type: EventType {
        didSet {
            self.hasMore = true
            self.events = [HTEvent]()
            self.loadMoreData()
        }
    }
    
    private var cancellable = Set<AnyCancellable>()
    
    init(_ month: Int = Date().month!, _ day: Int = Date().day!, type: EventType) {
        self.month = month
        self.day = day
        self.type = type
        loadMoreData()
    }
    
    func loadMoreData() {
        if !hasMore || isLoading {
            return
        }
        
        isLoading = true
        
        let param = EventReqParam(month: month, day: day, pageIndex: events.count, pageSize: 10, type: self.type)
        HTEventReqService.fetchEvents(param).sink { _ in
            
        } receiveValue: {
            if $0.count == 0 {
                self.hasMore = false
            } else {
                self.events.append(contentsOf: $0)
            }
            self.isLoading = false
        }
        .store(in: &cancellable)
    }
}

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
