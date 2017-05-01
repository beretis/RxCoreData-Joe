


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


public class PersistableOrEntity<P> :Equatable where P:Persistable, P: Hashable {
    
    private var entityValue: P.T?
    private var persistableValue: P?
    
    init(value: P.T) {
        self.entityValue = value
    }
    
    init(value: P) {
        self.persistableValue = value
    }
    
    
    func setValue(value: P) {
        self.entityValue = nil
        self.persistableValue = value
    }
    
    func setValue(value: P.T) {
        self.persistableValue = nil
        self.entityValue = value
    }
    
    func getPersistableValue() -> P {
        guard self.entityValue != nil || self.persistableValue != nil else { fatalError("this object needs to have value") }
        guard self.persistableValue != nil else {
            let result = P(entity: self.entityValue!)
            self.setValue(value: result)
            return result
        }
        return self.persistableValue!
    }
    
    func getEntityValue(context: NSManagedObjectContext? = coreDataStack.managedObjectContext) -> P.T {
        guard context != nil else { fatalError("context cant be nil") }
        guard self.entityValue != nil || self.persistableValue != nil else { fatalError("this object needs to have value") }
        guard self.entityValue != nil else {
            let result = self.persistableValue!.toEntity(context: context!)
            self.setValue(value: result)
            return result
        }
        return self.entityValue!
    }
}

public func ==<P>(lhs: PersistableOrEntity<P>, rhs: PersistableOrEntity<P>) -> Bool where P:Persistable, P: Hashable {
    return lhs.getPersistableValue().identity == rhs.getPersistableValue().identity
}

extension PersistableOrEntity: Hashable {
    public var hashValue: Int { return self.getPersistableValue().identity.hashValue }
}


public struct ToOneRelationship<P> where P:Persistable, P: Hashable {
    let key: String
    private var value: PersistableOrEntity<P>?
    
    mutating func setValue(_ newValue: P) {
        guard self.value != nil else {
            self.value = PersistableOrEntity(value: newValue)
            return
        }
        self.value!.setValue(value: newValue)
    }
    
    mutating func setValue(_ newValue: P.T) {
        guard self.value != nil else {
            self.value = PersistableOrEntity(value: newValue)
            return
        }
        self.value!.setValue(value: newValue)
    }
    
    func getValue() -> P? {
        guard self.value != nil else {
            return nil
        }
        return self.value!.getPersistableValue()
    }
    
    func update(ToEntity entity: P.T) {
        self.save(ToEntity: entity)
    }
    
    func save(ToEntity entity: P.T) {
        guard self.value != nil else { return }
        entity.setValue(self.value!.getEntityValue(), forKey: key)
    }
    
    init(key: String) {
        self.key = key
    }
    
}



/// To many relationship class , it guarantees unique items in items (based on Identity of persistable). Main problem was relationship creating infinite loop of dependencies, it was resolved by using PersistableOrEntity instead of Persistable so the Persistable's function toEntity isn't called every time.
public struct ToManyRelationship<P> where P:Persistable, P:Hashable {
    public var key: String
    private var items: Array<PersistableOrEntity<P>>?
    
    init(key: String) {
        self.key = key
    }
    
    mutating func setValue(_ value: [P] ) {
        let value = value.map { item in
            return PersistableOrEntity<P>(value: item)
        }
        self.items = value
    }
    
    mutating func setValue(_ value: Set<P.T> ) {
        let value = value.map { item in
            return PersistableOrEntity<P>(value: item)
        }
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
        let persistableOrEntity = PersistableOrEntity<P>(value: item)
        guard self.items != nil else {
            return self.items = [persistableOrEntity]
        }
        if let index = self.items?.index(of: persistableOrEntity) {
            return self.items![index].setValue(value: item)
        }
        self.items!.append(persistableOrEntity)
    }
    
    func value() -> [P] {
        guard let value = self.items else { return [] }
        return value.map { item in
            item.getPersistableValue()
            }.flatMap { $0 }
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
        //TODO: save only if differs from entity (might be too big burden for performance)
        let entities = Set(items!.map { $0.getEntityValue(context: entity.managedObjectContext!) }) as! Set<NSManagedObject>
        entity.setValue(entities, forKey: self.key)
    }
    
    var isEmpty: Bool {
        guard self.items != nil else { return true }
        return items!.count < 1
    }
    
}




