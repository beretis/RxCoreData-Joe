//
//  Test.swift
//  pexeso
//
//  Created by Jozef Matus on 17/02/17.
//  Copyright © 2017 o2. All rights reserved.
//

import UIKit
import CoreData
import RxDataSources


struct MainEntity: Persistable {
    
    public typealias T = NSManagedObject
    
    var identity: String
    var value: String
    var childsa: ToManyRelationship<ChildA> = ToManyRelationship(key: "childsa")
    var childsb: ToManyRelationship<ChildB> = ToManyRelationship(key: "childsb")
    var childsc: ToManyRelationship<ChildC> = ToManyRelationship(key: "childsc")
    var childsd: ToManyRelationship<ChildD> = ToManyRelationship(key: "childsd")
    var childse: ToManyRelationship<ChildE> = ToManyRelationship(key: "childse")

    //    var parent: ToOneRelationship<Main>
    
    public static var primaryAttributeName: String {
        return "id"
    }
    
    init(id: String, value: String) {
        self.identity = id
        self.value = value
    }
    
    
    init(entity: T) {
        self.identity = entity.value(forKey: "id") as! String
        self.value = entity.value(forKey: "value") as! String
        //relationships
        if let childsaEntities = entity.value(forKey: "childsa") as? Set<ChildA.T>, childsaEntities.count > 0 {
            self.childsa.setValue(childsaEntities)
        }
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(self.identity, forKey: "id")
        entity.setValue(self.value, forKey: "value")
        self.childsa.save(ToEntity: entity)
        self.childsb.save(ToEntity: entity)
        self.childsc.save(ToEntity: entity)
        self.childsd.save(ToEntity: entity)
        self.childse.save(ToEntity: entity)

    }
    
    func softUpdate(_ entity: NSManagedObject) {
        
    }
    
}

struct ChildA: Persistable {
    
    public typealias T = NSManagedObject

    var identity: String
    var value: String
    var parent: ToOneRelationship<MainEntity> = ToOneRelationship(key: "parent")
    
    public static var primaryAttributeName: String {
        return "id"
    }
    
    init(id: String, value: String) {
        self.identity = id
        self.value = value
    }
    
    init(entity: T) {
        self.identity = entity.value(forKey: "id") as! String
        self.value = entity.value(forKey: "value") as! String
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(self.identity, forKey: "id")
        entity.setValue(self.value, forKey: "value")
        self.parent.save(ToEntity: entity)
    }
    
    func softUpdate(_ entity: NSManagedObject) {
        
    }
    
}

struct ChildB: Persistable {
    public typealias T = NSManagedObject
    
    var identity: String
    var value: String
    var parent: ToOneRelationship<MainEntity> = ToOneRelationship(key: "parent")
    
    public static var primaryAttributeName: String {
        return "id"
    }
    init(id: String, value: String) {
        self.identity = id
        self.value = value
    }
    
    init(entity: T) {
        self.identity = entity.value(forKey: "id") as! String
        self.value = entity.value(forKey: "value") as! String
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(self.identity, forKey: "id")
        entity.setValue(self.value, forKey: "value")
        self.parent.save(ToEntity: entity)
    }
    
    func softUpdate(_ entity: NSManagedObject) {
        
    }
}

struct ChildC: Persistable {
    public typealias T = NSManagedObject
    
    var identity: String
    var value: String
    var parent: ToOneRelationship<MainEntity> = ToOneRelationship(key: "parent")

    public static var primaryAttributeName: String {
        return "id"
    }
    init(id: String, value: String) {
        self.identity = id
        self.value = value
    }
    
    init(entity: T) {
        self.identity = entity.value(forKey: "id") as! String
        self.value = entity.value(forKey: "value") as! String
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(self.identity, forKey: "id")
        entity.setValue(self.value, forKey: "value")
        self.parent.save(ToEntity: entity)
    }
    
    func softUpdate(_ entity: NSManagedObject) {
        
    }
}

struct ChildD: Persistable {
    public typealias T = NSManagedObject
    
    var identity: String
    var value: String
    var parent: ToOneRelationship<MainEntity> = ToOneRelationship(key: "parent")

    public static var primaryAttributeName: String {
        return "id"
    }
    init(id: String, value: String) {
        self.identity = id
        self.value = value
    }
    
    init(entity: T) {
        self.identity = entity.value(forKey: "id") as! String
        self.value = entity.value(forKey: "value") as! String
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(self.identity, forKey: "id")
        entity.setValue(self.value, forKey: "value")
        self.parent.save(ToEntity: entity)
    }
    
    func softUpdate(_ entity: NSManagedObject) {
        
    }
}

struct ChildE: Persistable {
    public typealias T = NSManagedObject
    
    var identity: String
    var value: String
    var parent: ToOneRelationship<MainEntity> = ToOneRelationship(key: "parent")

    public static var primaryAttributeName: String {
        return "id"
    }
    init(id: String, value: String) {
        self.identity = id
        self.value = value
    }
    
    init(entity: T) {
        self.identity = entity.value(forKey: "id") as! String
        self.value = entity.value(forKey: "value") as! String
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(self.identity, forKey: "id")
        entity.setValue(self.value, forKey: "value")
        self.parent.save(ToEntity: entity)
    }
    
    func softUpdate(_ entity: NSManagedObject) {
        
    }
}

struct Parent: Persistable {
    public typealias T = NSManagedObject
    
    var identity: String
    var value: String
    var parent: ToOneRelationship<MainEntity> = ToOneRelationship(key: "parent")

    public static var primaryAttributeName: String {
        return "id"
    }
    init(id: String, value: String) {
        self.identity = id
        self.value = value
    }
    
    init(entity: T) {
        self.identity = entity.value(forKey: "id") as! String
        self.value = entity.value(forKey: "value") as! String
    }
    
    func update(_ entity: NSManagedObject) {
        
    }
    
    func softUpdate(_ entity: NSManagedObject) {
        
    }
}



struct Mamrd {
    var id: String
    var value: String
    var zmrdi: ToManyRelationship<Zmrd> = ToManyRelationship<Zmrd>(key: "zmrdi")
    
    init(id: String, value: String) {
        self.id = id
        self.value = value
    }
}

extension Mamrd: Persistable {
    public typealias T = NSManagedObject
    
    public static var entityName: String {
        return "Mamrd"
    }
    
    public static var primaryAttributeName: String {
        return "id"
    }
    
    var identity: String {
        return id
    }
    
    init(entity: T) {
        self.id = entity.value(forKey: "id") as! String
        self.value = entity.value(forKey: "value") as! String
        if let zmrdiEntities = entity.value(forKey: "zmrdi") as? Set<Zmrd.T>, zmrdiEntities.count > 0 {
            self.zmrdi.setValue(zmrdiEntities)
        }
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(self.id, forKey: "id")
        entity.setValue(self.value, forKey: "value")
        self.zmrdi.save(ToEntity: entity)
    }
    
}

extension Mamrd: Equatable {}

func ==(lhs: Mamrd, rhs: Mamrd) -> Bool {
    return lhs.id == rhs.id
}

extension Mamrd: Hashable {
    
    var hashValue: Int { return self.identity.hashValue }
}

struct Zmrd {
    var id: String
    var value: String
    var mamrd: ToOneRelationship<Mamrd> = ToOneRelationship<Mamrd>(key:"mamrd")
    
    init(id: String, value: String) {
        self.id = id
        self.value = value
    }
    
}

extension Zmrd: Persistable {
    public typealias T = NSManagedObject
    
    public static var entityName: String {
        return "Zmrd"
    }
    
    public static var primaryAttributeName: String {
        return "id"
    }
    
    var identity: String {
        return id
    }
    
    init(entity: T) {
        self.id = entity.value(forKey: "id") as! String
        self.value = entity.value(forKey: "value") as! String
        print(entity)
        if let mamrdEntity = entity.value(forKey: "mamrd") as? Mamrd.T {
            self.mamrd.setValue(mamrdEntity)
        }
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(self.id, forKey: "id")
        entity.setValue(self.value, forKey: "value")
        self.mamrd.save(ToEntity: entity)
    }
}

extension Zmrd: Equatable {}

func ==(lhs: Zmrd, rhs: Zmrd) -> Bool {
    return lhs.identity == rhs.identity
}

extension Zmrd: Hashable {
    public var hashValue: Int { return self.id.hashValue }
}


//extension Persistable where Self: IdentifiableType {
//    public typealias T = NSManagedObject
//    
//    public static var entityName: String {
//        return Self
//    }
//    
//    public static var primaryAttributeName: String {
//        return "id"
//    }
//}
//
//
//extension Mamrd: IdentifiableType {
//    
//    public typealias Identity = String
//    public var identity: Identity { return id }
//}
