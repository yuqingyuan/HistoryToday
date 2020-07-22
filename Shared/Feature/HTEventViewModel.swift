//
//  HTEventViewModel.swift
//  iOS
//
//  Created by yuqingyuan on 2020/7/20.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import Foundation
import Combine
import OSLog

class HTEventViewModel: ObservableObject {
    
    @Published var events = [HTEvent]()
    @Published var hasMore: Bool = true
    var month: Int
    var day: Int
    
    private var cancellable = Set<AnyCancellable>()
    
    init(_ month: Int = Date().month!, _ day: Int = Date().day!) {
        self.month = month
        self.day = day
        loadMoreData()
    }
    
    func loadMoreData() {
        if !hasMore {
            return
        }
        
        let param = EventReqParam(month: month, day: day, pageIndex: events.count, pageSize: 20, type: .all)
        HTEventReqService.fetchEvents(param)
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    self.hasMore = false
                case .failure(let err):
                    os_log(.error, "【HTEventViewModel】%s", err.localizedDescription)
                }
            }, receiveValue: {
                self.events.append(contentsOf: $0)
            })
            .store(in: &cancellable)
    }
}
