//
//  HTCoreDataManager.swift
//  HistoryToday
//
//  Created by yuqingyuan on 2020/7/1.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData
import Combine
import os

fileprivate let logger = Logger(subsystem: "com.qingyuanyu.HistoryToday", category: "CoreData")

class HTCoreDataManager: NSObject {
    static let shared = HTCoreDataManager()
    
    lazy var context: NSManagedObjectContext = {
        return createHTEventMainContext()
    }()
    
    var entity: NSEntityDescription? {
        NSEntityDescription.entity(forEntityName: "HTEvent", in: context)
    }
}

extension HTCoreDataManager {

    private var storeURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("HTEvent.sqlite")
    }
    
    private func createHTEventMainContext() -> NSManagedObjectContext {
        let bundle = Bundle(for: HTEvent.classForCoder())
        guard let model = NSManagedObjectModel.mergedModel(from: [bundle]) else {
            logger.fault("model not found")
            fatalError("【CoreData】model not found")
        }
        let persistent = NSPersistentStoreCoordinator(managedObjectModel: model)
        do {
            try persistent.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            let err = error as NSError
            logger.error("create context error \(err.userInfo)")
        }
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistent
        context.stalenessInterval = 0
        return context
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let err = error as NSError
                logger.error("saving context error \(err.userInfo)")
            }
        }
    }
    
    public func insertEvents(_ events: [JSON], date: String) -> [HTEvent] {
        var htEvents = [HTEvent]()
        if let entity = entity {
            for event in events {
                htEvents.append(HTEvent(entity, json: event, date: date, context: context))
            }
            saveContext()
        } else {
            logger.error("insert event error")
        }
        return htEvents
    }
    
    public func getEvents(_ param: EventReqParam) -> CurrentValueSubject<[HTEvent], Error> {
        let fetchReq: NSFetchRequest<HTEvent> = HTEvent.fetchRequest()
        fetchReq.sortDescriptors = [.init(key: "id", ascending: true)]
        fetchReq.fetchOffset = param.pageIndex
        fetchReq.fetchLimit = param.pageSize
        let predicate = "date = '\(param.month)-\(param.day)' and type = '\(param.type.rawValue)'"
        fetchReq.predicate = NSPredicate(format: predicate)
        let publisher = CurrentValueSubject<[HTEvent], Error>([])
        do {
            let result: [HTEvent] = try context.fetch(fetchReq)
            if result.count == 0 {
                publisher.send(completion: .failure(NSError(domain: "", code: -1, userInfo: nil)))
            } else {
                publisher.send(result)
            }
        } catch {
            publisher.send(completion: .failure(error))
            logger.error("get events error, month = \(param.month), day = \(param.day)")
        }
        return publisher
    }
}
