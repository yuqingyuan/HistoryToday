//
//  HTEventReqService.swift
//  iOS
//
//  Created by yuqingyuan on 2020/7/16.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import Foundation
import SwiftyJSON
import Combine

enum EventType: Int {
    case all = -1
    case normal, birth, death
}

struct EventReqParam {
    var month: Int
    var day: Int
    var pageIndex: Int
    var pageSize: Int
    var type: EventType
    
    var queryParams: String {
        return "?month=\(month)&day=\(day)&pageIndex=\(pageIndex)&pageSize=\(pageSize)&type=\(type.rawValue)"
    }
}

class HTEventReqService {
    
    private static let eventApi: String = "http://150.109.53.41:8080/ht"
    
    static func fetchEvents(_ param: EventReqParam) -> AnyPublisher<[HTEvent], Error> {
        
        let publisher = URLSession.shared.dataTaskPublisher(for: URL(string: eventApi + param.queryParams)!)
            .receive(on: DispatchQueue.main)
            .tryMap {
                guard let res = $0.response as? HTTPURLResponse, res.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                guard let json = try? JSON(data: $0.data),
                    let content = json.dictionary?["content"],
                    let date = content["date"].string,
                    let events = content["events"].array else {
                    throw SwiftyJSONError.invalidJSON
                }
                return (date, events)
            }
            .map { (date: String, events: [JSON]) -> [HTEvent] in
                return HTCoreDataManager.shared.insertEvents(events, date: date)
            }
            .eraseToAnyPublisher()
        
        return HTCoreDataManager.shared.getEvents(param)
            .receive(on: DispatchQueue.main)
            .tryMap {
                if $0.count == 0 {
                    throw NSError(domain: "", code: -1, userInfo: nil)
                }
                return $0
            }
            .catch { _ in
                return publisher
            }
            .eraseToAnyPublisher()
    }
}
