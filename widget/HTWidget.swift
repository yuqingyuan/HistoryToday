//
//  Widget.swift
//  Widget
//
//  Created by yuqingyuan on 2020/9/1.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HTCardImageView(imgURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Republica_Romana.svg/1200px-Republica_Romana.svg.png")
    }
}

@main
struct HTWidget: Widget {
    let kind: String = "com.qingyuanyu.HistoryToday.Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("历史上的今天")
        .description("来看看历史上的今天发生了什么。")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
