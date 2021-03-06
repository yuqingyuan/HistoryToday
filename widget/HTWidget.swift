//
//  Widget.swift
//  Widget
//
//  Created by yuqingyuan on 2020/9/1.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import WidgetKit
import SwiftUI

struct HTWidgetEntryView : View {
    var entry: HTEntryProvider.Entry

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
            }
            .padding([.leading, .trailing])
            
            Spacer()
        }
        .foregroundColor(Color("mainTextColor"))
        .background(Color("mainViewColor"))
    }
}

@main
struct HTWidget: Widget {
    let kind: String = "com.qingyuanyu.HistoryToday.Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HTEntryProvider()) { entry in
            HTWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("历史上的今天")
        .description("来看看历史上的今天发生了什么。")
        .supportedFamilies([.systemSmall])
    }
}

#if DEBUG
struct Widget_Previews: PreviewProvider {
    
    static let sampleEntry = HTSimpleEventEntry(date: Date(), eventYear: "2020", detail: "历史上的今天")
    
    static var previews: some View {
        Group {
            HTWidgetEntryView(entry: sampleEntry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
#endif
