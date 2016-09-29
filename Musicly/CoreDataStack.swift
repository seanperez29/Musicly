//
//  CoreDataStack.swift
//  Musicly
//
//  Created by Sean Perez on 9/25/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import CoreData

typealias BatchTask = (_ workerContext: NSManagedObjectContext) -> ()

enum CoreDataStackNotifications : String {
    case ImportingTaskDidFinish = "ImportingTaskDidFinish"
}

struct CoreDataStack {
    
    fileprivate let model: NSManagedObjectModel
    fileprivate let coordinator: NSPersistentStoreCoordinator
    fileprivate let modelURL: URL
    fileprivate let dbURL: URL
    fileprivate let persistingContext: NSManagedObjectContext
    fileprivate let backgroundContext: NSManagedObjectContext
    let context: NSManagedObjectContext
    
    init?(modelName: String) {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            print("Unable to find \(modelName)in the main bundle")
            return nil}
        self.modelURL = modelURL
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            print("unable to create a model from \(modelURL)")
            return nil
        }
        self.model = model
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        persistingContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        persistingContext.name = "Persisting"
        persistingContext.persistentStoreCoordinator = coordinator
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = persistingContext
        context.name = "Main"
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = context
        backgroundContext.name = "Background"
        let fm = FileManager.default
        guard let  docUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first else{
            print("Unable to reach the documents folder")
            return nil
        }
        self.dbURL = docUrl.appendingPathComponent("model.sqlite")
        do {
            try addStoreTo(coordinator: coordinator,
                           storeType: NSSQLiteStoreType,
                           configuration: nil,
                           storeURL: dbURL,
                           options: nil)
        } catch {
            print("unable to add store at \(dbURL)")
        }
    }
    
    func addStoreTo(coordinator coord : NSPersistentStoreCoordinator, storeType: String, configuration: String?, storeURL: URL, options : [AnyHashable: Any]?) throws {
        try coord.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbURL, options: nil)
    }
}

extension CoreDataStack {
    
    func dropAllData() throws {
        try coordinator.destroyPersistentStore(at: dbURL, ofType:NSSQLiteStoreType , options: nil)
        try addStoreTo(coordinator: self.coordinator, storeType: NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: nil)
    }
}

extension CoreDataStack {
    
    func performBackgroundBatchOperation(_ batch: @escaping BatchTask) {
        backgroundContext.perform() {
            batch(self.backgroundContext)
            do {
                try self.backgroundContext.save()
            } catch {
                fatalError("Error while saving backgroundContext: \(error)")
            }
        }
    }
}

extension CoreDataStack {
    
    func performBackgroundImportingBatchOperation(_ batch: @escaping BatchTask) {
        let tmpCoord = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        do {
            try addStoreTo(coordinator: tmpCoord, storeType: NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: nil)
        } catch {
            fatalError("Error adding a SQLite Store: \(error)")
        }
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.name = "Importer"
        moc.persistentStoreCoordinator = tmpCoord
        moc.perform() {
            batch(moc)
            do {
                try moc.save()
            } catch {
                fatalError("Error saving importer moc: \(moc)")
            }
            let nc = NotificationCenter.default
            let n = Notification(name: Notification.Name(rawValue: CoreDataStackNotifications.ImportingTaskDidFinish.rawValue), object: nil)
            nc.post(n)
        }
    }
}

extension CoreDataStack {
    
    func save() {
        context.performAndWait(){
            if self.context.hasChanges {
                do {
                    try self.context.save()
                } catch {
                    fatalError("Error while saving main context: \(error)")
                }
                self.persistingContext.perform() {
                    do {
                        try self.persistingContext.save()
                    } catch {
                        fatalError("Error while saving persisting context: \(error)")
                    }
                }
            }
        }
    }
    
    func autoSave(_ delayInSeconds : Int) {
        if delayInSeconds > 0 {
            print("Autosaving")
            save()
            let delayInNanoSeconds = UInt64(delayInSeconds) * NSEC_PER_SEC
            let time = DispatchTime.now() + Double(Int64(delayInNanoSeconds)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                self.autoSave(delayInSeconds)
            })
        }
    }
    
    static func sharedInstance() -> CoreDataStack {
        struct Static {
            static let instance = CoreDataStack(modelName: "Model")
        }
        return Static.instance!
    }
}
