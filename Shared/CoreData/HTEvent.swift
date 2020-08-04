//
//  HTEvent.swift
//  HistoryToday
//
//  Created by yuqingyuan on 2020/6/30.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

public class HTEventManagedObject: NSManagedObject {
    
}

@objc(HTEvent)
public final class HTEvent: HTEventManagedObject, Identifiable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<HTEvent> {
        return NSFetchRequest<HTEvent>(entityName: "HTEvent")
    }
    
    @NSManaged public private(set) var id: Int64
    @NSManaged public private(set) var type: Int16
    @NSManaged public private(set) var year: String
    @NSManaged public private(set) var date: String
    @NSManaged public private(set) var detail: String
    @NSManaged public private(set) var links: Dictionary<String, String>?
    @NSManaged public private(set) var imgs: [String]
    
    public convenience init(_ entity: NSEntityDescription, json: JSON, date: String, context: NSManagedObjectContext) {
        self.init(entity: entity, insertInto: context)
        
        self.date = date
        id = json["id"].int64Value
        type = json["type"].int16Value
        year = json["year"].stringValue
        detail = json["detail"].stringValue
        imgs = json["images"].arrayValue
            .filter { $0.stringValue.count != 0 }
            .map { "https://upload.wikimedia.org/wikipedia" + $0.stringValue }
        
        if let data = json["links"].stringValue.data(using: .utf8),
           let linkDict = JSON(data).dictionaryObject as? Dictionary<String, String> {
            links = linkDict
        }
    }
}

#if DEBUG
var preview_event: HTEvent {
    let path = Bundle.main.path(forResource: "HTEventTest", ofType: "json")!
    let json = try! JSON(data: Data(contentsOf: URL(fileURLWithPath: path)))
    return HTEvent(HTCoreDataManager.shared.entity!, json: json, date: "1-1", context: HTCoreDataManager.shared.context)
}
#endif
