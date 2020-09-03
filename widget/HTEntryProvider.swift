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
        var entry = HTSimpleEventEntry(date: Date(), eventYear: String(Date().year!), imgURL: "", detail: "历史上的今天")
        entry.isPreview = context.isPreview
        return entry
    }

    func getSnapshot(in context: Context, completion: @escaping (HTSimpleEventEntry) -> ()) {
        var entry = HTSimpleEventEntry(date: Date(), eventYear: String(Date().year!), imgURL: "", detail: "历史上的今天")
        entry.isPreview = context.isPreview
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HTSimpleEventEntry>) -> ()) {
        let param = EventReqParam(month: Date().month!, day: Date().day!, pageIndex: 0, pageSize: 24, type: .normal)
        HTEventReqService.fetchEvents(param).sink { _ in
            
        } receiveValue: { events in
            var entries = [HTSimpleEventEntry]()
            let curDate = Date()
            for offset in 0 ..< events.count {
                let entryDate = curDate.addingTimeInterval(TimeInterval((offset+1)*15*60))
                var entry = HTSimpleEventEntry(date: entryDate, eventYear: events[offset].displayYear, imgURL: events[offset].imgs.first, detail: events[offset].detail)
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
    let imgURL: String?
    let detail: String
    
    var isPreview: Bool = false
}
