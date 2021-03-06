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
        if let childsbEntities = entity.value(forKey: "childsb") as? Set<ChildB.T>, childsbEntities.count > 0 {
            self.childsb.setValue(childsbEntities)
        }
        if let childscEntities = entity.value(forKey: "childsc") as? Set<ChildC.T>, childscEntities.count > 0 {
            self.childsc.setValue(childscEntities)
        }
        if let childsdEntities = entity.value(forKey: "childsd") as? Set<ChildD.T>, childsdEntities.count > 0 {
            self.childsd.setValue(childsdEntities)
        }
        if let childseEntities = entity.value(forKey: "childse") as? Set<ChildE.T>, childseEntities.count > 0 {
            self.childse.setValue(childseEntities)
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
        //relationships
        if let parentEntities = entity.value(forKey: "parent") as? MainEntity.T {
            self.parent.setValue(parentEntities)
        }
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(self.identity, forKey: "id")
        entity.setValue(self.value, forKey: "value")
        self.parent.save(ToEntity: entity)
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
        //relationships
        if let parentEntities = entity.value(forKey: "parent") as? MainEntity.T {
            self.parent.setValue(parentEntities)
        }
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(self.identity, forKey: "id")
        entity.setValue(self.value, forKey: "value")
        self.parent.save(ToEntity: entity)
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
        //relationships
        if let parentEntities = entity.value(forKey: "parent") as? MainEntity.T {
            self.parent.setValue(parentEntities)
        }
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(self.identity, forKey: "id")
        entity.setValue(self.value, forKey: "value")
        self.parent.save(ToEntity: entity)
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
        //relationships
        if let parentEntities = entity.value(forKey: "parent") as? MainEntity.T {
            self.parent.setValue(parentEntities)
        }
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(self.identity, forKey: "id")
        entity.setValue(self.value, forKey: "value")
        self.parent.save(ToEntity: entity)
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
        //relationships
        if let parentEntities = entity.value(forKey: "parent") as? MainEntity.T {
            self.parent.setValue(parentEntities)
        }
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(self.identity, forKey: "id")
        entity.setValue(self.value, forKey: "value")
        self.parent.save(ToEntity: entity)
    }
}




