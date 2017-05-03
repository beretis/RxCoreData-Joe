


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

public struct RelationshipFault {
    var faultId: String
    var context: NSManagedObjectContext
    
}

public struct ToOneRelationship<P> where P:Persistable, P: Hashable {
    let key: String
    private var value: P?
    private var fault: RelationshipFault?
    
    mutating func setValue(_ newValue: P) {
        self.fault = nil
        self.value = newValue
    }

    mutating func setValue(_ newValue: P.T) {
        guard let faultId = newValue.value(forKey: P.primaryAttributeName) as? String else {
            return
        }
        guard let context = newValue.managedObjectContext else {
            return
        }
        self.value = nil
        self.fault = RelationshipFault(faultId: faultId, context: context)
    }
    
    mutating func getValue() -> P? {
        if self.fault != nil {
            self.value = P.fetch(WithId: self.fault!.faultId, context: self.fault!.context)
            self.fault = nil
        }
        return self.value
    }
    
    func getFaultId() -> String? {
        guard fault != nil || value != nil else {
            return nil
        }
        guard fault != nil else {
            return self.value!.identity
        }
        return fault!.faultId
    }
    
    func update(ToEntity entity: P.T) {
        self.save(ToEntity: entity)
    }
    
    func save(ToEntity entity: P.T) {
        guard self.value != nil else { return }
        guard let context = entity.managedObjectContext else {
            return
        }
        entity.setValue(self.value!.toEntity(context: context), forKey: key)
    }
    
    init(key: String) {
        self.key = key
    }
    
}



/// To many relationship class , it guarantees unique items in items (based on Identity of persistable). Main problem was relationship creating infinite loop of dependencies, it was resolved by using PersistableOrEntity instead of Persistable so the Persistable's function toEntity isn't called every time.
public struct ToManyRelationship<P> where P:Persistable, P:Hashable {
    public var key: String
    private var items: Array<P>? {
        didSet {
            guard self.items != nil else {
                return
            }
            self.fault = nil
        }
    }
    private var fault: Array<RelationshipFault>? {
        didSet {
            guard self.fault != nil else {
                return
            }
            self.items = nil
        }
    }

    init(key: String) {
        self.key = key
    }
    
    mutating func setValue(_ value: [P] ) {
        self.items = value
    }
    
    mutating func setValue(_ value: Set<P.T>) {
        var faults: [RelationshipFault] = []
        for entity in value {
            guard let faultId = entity.value(forKey: P.primaryAttributeName) as? String else {
                continue
            }
            guard let context = entity.managedObjectContext else {
                continue
            }
            faults.append(RelationshipFault(faultId: faultId, context: context))
        }
        self.fault = faults
    }
    
    mutating func applyFaultIfNeeded() {
        if self.fault != nil {
            let faultItems = self.fault!.map { singleFault in
                P.fetch(WithId: singleFault.faultId, context: singleFault.context)
                }.flatMap{$0}
            self.items = faultItems
        }
    }
    
    mutating func addItems(_ items: [P]) {
        self.applyFaultIfNeeded()
        if self.items == nil {
            self.items = []
        }
        for item in items {
            self.addItem(item)
        }
    }
    
    mutating func addItem(_ item: P) {
        self.applyFaultIfNeeded()
        guard self.items != nil else {
            return self.items = [item]
        }
        if let index = self.items?.index(of: item) {
            return self.items![index] = item
        }
        self.items!.append(item)
    }
    
    
    mutating func value() -> [P] {
        self.applyFaultIfNeeded()
        guard let value = self.items else { return [] }
        return value
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
            return item.toEntity(context: context)
        })
        entity.setValue(entitySet, forKey: self.key)
    }
    
    var isEmpty: Bool {
        guard self.items != nil || self.fault != nil else {
            return true
        }
        return items!.count < 1
    }
    
}





