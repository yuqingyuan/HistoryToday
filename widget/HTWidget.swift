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
        HTSimpleEventEntry(date: Date(), eventYear: "", imgURL: "", detail: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (HTSimpleEventEntry) -> ()) {
        let entry = HTSimpleEventEntry(date: Date(), eventYear: "", imgURL: "", detail: "")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let param = EventReqParam(month: Date().month!, day: Date().day!, pageIndex: 0, pageSize: 5, type: .normal)
        HTEventReqService.fetchEvents(param).sink { _ in
            
        } receiveValue: { events in
            var entries = [HTSimpleEventEntry]()
            let curDate = Date()
            for offset in 0 ..< events.count {
                let entryDate = Calendar.current.date(byAdding: .hour, value: offset, to: curDate)!
                let entry = HTSimpleEventEntry(date: entryDate, eventYear: events[offset].displayYear, imgURL: events[offset].imgs.first, detail: events[offset].detail)
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
    var formattedDate: String {
        "\(eventYear)年\(date.month!)月\(date.day!)日"
    }
}

struct HTWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            VStack(spacing: 16) {
                HTCardImageView(imgURL: entry.imgURL ?? "")
                    .frame(width: 130, height: 100)
                    .shadow(radius: 1)
                Text(entry.formattedDate)
                    .font(.custom(commonFontName, size: 16))
            }
            .padding()
            
            VStack {
                Text(entry.detail)
                    .font(.custom(commonFontName, size: 17))
                
                Spacer()
            }
            .padding([.top, .trailing])
            
            Spacer()
        }
        .foregroundColor(.white)
        .background(
            LinearGradient(gradient: Gradient(colors: [rgb(18, 17, 24), rgb(49, 53, 69)]),
                           startPoint: .top,
                           endPoint: .center)
                .ignoresSafeArea()
        )
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
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#if DEBUG
struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        HTWidgetEntryView(entry: HTSimpleEventEntry(date: Date(), eventYear: "", imgURL: "", detail: ""))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
#endif
