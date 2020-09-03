//
//  Widget.swift
//  Widget
//
//  Created by yuqingyuan on 2020/9/1.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import WidgetKit
import SwiftUI
import Combine

var cancellable = Set<AnyCancellable>()

struct Provider: TimelineProvider {
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

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
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

struct HTWidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) private var widgetFamily
    
    var body: some View {
        VStack {
            HStack {
                Text(entry.eventYear+" 年")
                    .font(.custom(ktFont, size: 15))
                    .redacted(reason: entry.isPreview ? .placeholder : .init())
                
                Spacer()
                
                Image(systemName: "newspaper")
                    .redacted(reason: entry.isPreview ? .placeholder : .init())
            }
            .padding([.leading, .top, .trailing])
            
            Divider()
                .background(Color.white)
            
            HStack(alignment:.top) {
                Text(entry.detail)
                    .font(.custom(ktFont, size: 15))
                    .redacted(reason: entry.isPreview ? .placeholder : .init())
                
                Spacer()
                
                if widgetFamily != .systemSmall {
                    if entry.isPreview {
                        Image(systemName: "photo")
                            .redacted(reason: .placeholder)
                    } else {
                        HTCardImageView(imgURL: "")
                            .frame(width: 80, height: 80)
                    }
                }
            }
            .padding([.leading, .trailing])
            
            Spacer()
        }
        .foregroundColor(.white)
        .background(rgb(47, 49, 54))
    }
}

@main
struct HTWidget: Widget {
    let kind: String = "com.qingyuanyu.HistoryToday.Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HTWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("历史上的今天")
        .description("来看看历史上的今天发生了什么。")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#if DEBUG
struct Widget_Previews: PreviewProvider {
    
    static let sampleEntry = HTSimpleEventEntry(date: Date(), eventYear: "2020", imgURL: "", detail: "历史上的今天")
    
    static var previews: some View {
        Group {
            HTWidgetEntryView(entry: sampleEntry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            HTWidgetEntryView(entry: sampleEntry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
#endif
