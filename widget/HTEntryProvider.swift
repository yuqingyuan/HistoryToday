//
//  HTEntryProvider.swift
//  iOS
//
//  Created by yuqingyuan on 2020/9/3.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import WidgetKit
import Combine

var cancellable = Set<AnyCancellable>()

struct HTEntryProvider: TimelineProvider {
    func placeholder(in context: Context) -> HTSimpleEventEntry {
        var entry = HTSimpleEventEntry(date: Date(), eventYear: String(Date().year!), detail: "历史上的今天")
        entry.isPreview = context.isPreview
        return entry
    }

    func getSnapshot(in context: Context, completion: @escaping (HTSimpleEventEntry) -> ()) {
        // 预览
        let param = EventReqParam(month: Date().month!, day: Date().day!, pageIndex: 0, pageSize: 1, type: .normal)
        HTEventReqService.fetchEvents(param).sink { _ in
            
        } receiveValue: { events in
            if let event = events.first {
                let entry = HTSimpleEventEntry(date: Date(), eventYear: event.displayYear, detail: event.detail)
                completion(entry)
            }
        }
        .store(in: &cancellable)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HTSimpleEventEntry>) -> ()) {
        // 拉取全部事件，5分钟刷新一次
        let param = EventReqParam(month: Date().month!, day: Date().day!, pageIndex: 0, pageSize: 24, type: .normal)
        HTEventReqService.fetchEvents(param).sink { _ in
            
        } receiveValue: { events in
            var entries = [HTSimpleEventEntry]()
            let curDate = Date()
            for offset in 0 ..< events.count {
                let entryDate = Calendar.current.date(byAdding: .minute, value: offset*5, to: curDate)!
                var entry = HTSimpleEventEntry(date: entryDate, eventYear: events[offset].displayYear, detail: events[offset].detail)
                entry.isPreview = context.isPreview
                entries.append(entry)
            }
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }.store(in: &cancellable)
    }
}

struct HTSimpleEventEntry: TimelineEntry {
    let date: Date
    let eventYear: String
    let detail: String
    
    var isPreview: Bool = false
}
