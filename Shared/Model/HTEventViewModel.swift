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
    var isLoading: Bool = false
    var month: Int
    var day: Int
    
    private var cancellable = Set<AnyCancellable>()
    
    init(_ month: Int = Date().month!, _ day: Int = Date().day!) {
        self.month = month
        self.day = day
        loadMoreData()
    }
    
    func loadMoreData(_ item: HTEvent? = nil) {
        if !hasMore || isLoading {
            return
        }
        
        isLoading = true
        
        let param = EventReqParam(month: month, day: day, pageIndex: events.count, pageSize: 10, type: .all)
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

#if DEBUG
var preview_eventVM: HTEventViewModel {
    let viewmodel = HTEventViewModel()
    viewmodel.events.append(contentsOf: Array(repeating: preview_event, count: 10))
    return viewmodel
}
#endif
