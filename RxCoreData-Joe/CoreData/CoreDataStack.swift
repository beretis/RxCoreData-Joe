//
//  CoreDataStack.swift
//  pexeso
//
//  Created by Jozef Matus on 06/09/16.
//  Copyright © 2016 o2. All rights reserved.
//

import Foundation
import CoreData

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
//MARK: - Definitions

public let coreDataStack = CoreDataStack(modelURL: Bundle.main.url(forResource: "RxCoreData_Joe", withExtension: "momd")!)

public let testCoreDataStack = CoreDataStack(modelURL: Bundle.main.url(forResource: "RxCoreData_Joe", withExtension: "momd")!)

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Implementation

open class CoreDataStack {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    
    let modelURL : URL
    
    public init(modelURL: URL) {
        
        self.modelURL = modelURL
    }
    
    open lazy var managedObjectModel: NSManagedObjectModel = {
        
        return NSManagedObjectModel(contentsOf: self.modelURL)!
    }()
    
    
    open lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator! = {
        
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let docURL = self.applicationDocumentsDirectory
        let storeURL = docURL.appendingPathComponent("DataModel.sqlite")
        let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true,
                        NSInferMappingModelAutomaticallyOption: true]
        
        do {
//            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: mOptions)
            try coordinator!.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)

        } catch {
            coordinator = nil
            abort()
        }
        
        return coordinator
    }()
    
    open lazy var managedObjectContext: NSManagedObjectContext! = {
        
        guard let coordinator = self.persistentStoreCoordinator else {
            return nil
        }
        
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return managedObjectContext
    }()
    
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.romakrim.hippodile" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Public
    
}

