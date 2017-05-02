


//
//  CoreDataRelationships.swift
//  pexeso
//
//  Created by Jozef Matus on 24/01/17.
//  Copyright © 2017 o2. All rights reserved.
//

import Foundation
import CoreData
import RxDataSources
import RxSwift
import RxCocoa


public struct ToOneRelationship<P> where P:Persistable, P: Hashable {
    let key: String
    private var value: P?
    private var fault: String?
    
    mutating func setValue(_ newValue: P) {
        self.value = newValue
    }

    mutating func setValue(_ newValue: P.T) {
        guard let faultId = newValue.value(forKey: P.primaryAttributeName) as? String else {
            return
        }
        self.value = nil
        self.fault = faultId
    }
    
    mutating func getValue() -> P? {
        guard self.fault == nil else {
            self.value = 
        }
        return self.value
    }
    
    func update(ToEntity entity: P.T) {
        self.save(ToEntity: entity)
    }
    
    func save(ToEntity entity: P.T) {
        guard self.value != nil else { return }
        guard let context = entity.managedObjectContext else {
            return
        }
        entity.setValue(self.getEntityWithoutRelationships(forPersistable: self.value!, inContext: context), forKey: key)
    }
    
    func getEntityWithoutRelationships(forPersistable persistable: P, inContext context: NSManagedObjectContext) -> P.T {
        var entity = context.getOrCreateEntity(for: persistable)
        persistable.updateWithouRelationships(entity)
        return entity
    }
    
    init(key: String) {
        self.key = key
    }
    
}



/// To many relationship class , it guarantees unique items in items (based on Identity of persistable). Main problem was relationship creating infinite loop of dependencies, it was resolved by using PersistableOrEntity instead of Persistable so the Persistable's function toEntity isn't called every time.
public struct ToManyRelationship<P> where P:Persistable, P:Hashable {
    public var key: String
    private var items: Array<P>?
    
    init(key: String) {
        self.key = key
    }
    
    mutating func setValue(_ value: [P] ) {
        self.items = value
    }
    
    mutating func addItems(_ items: [P]) {
        if self.items == nil {
            self.items = []
        }
        for item in items {
            self.addItem(item)
        }
    }
    
    mutating func addItem(_ item: P) {
        guard self.items != nil else {
            return self.items = [item]
        }
        if let index = self.items?.index(of: item) {
            return self.items![index] = item
        }
        self.items!.append(item)
    }
    
    func value() -> [P] {
        guard let value = self.items else { return [] }
        return value
    }
    //TODO
    func interleave(ToEntity entity: NSManagedObject) {
        
    }
    
    /// This funcion will save items array to entity no metter what...so if you empty array of items it weill delete your current data
    ///
    /// - Parameter entity: entity to which save
    func save(ToEntity entity: NSManagedObject) {
        guard self.items != nil else {
            return
        }
        guard let context = entity.managedObjectContext else {
            return
        }
        
        let entitySet = Set<P.T>(self.items!.map { item in
            return self.getEntityWithoutRelationships(forPersistable: item, inContext: context)
        })
        entity.setValue(entitySet, forKey: self.key)
        
    }
    
    func getEntityWithoutRelationships(forPersistable persistable: P, inContext context: NSManagedObjectContext) -> P.T {
        var entity = context.getOrCreateEntity(for: persistable)
        persistable.updateWithouRelationships(entity)
        return entity
    }
    
    var isEmpty: Bool {
        guard self.items != nil else { return true }
        return items!.count < 1
    }
    
}





