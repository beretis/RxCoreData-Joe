//
//  Persistable.swift
//  RxCoreData
//
//  Created by Krunoslav Zaher on 5/19/16.
//  Copyright © 2016 Krunoslav Zaher. All rights reserved.
//

import Foundation
import CoreData

func ==<P: Persistable>(lhs: P, rhs: P) -> Bool {
    return true
}

public protocol Persistable: Equatable, Hashable {
    associatedtype T: NSManagedObject
    
    static var entityName: String { get }
    
    /// The attribute name to be used to uniquely identify each instance.
    static var primaryAttributeName: String { get }
    
    var identity: String { get }

    init(entity: T)

    func update(_ entity: T)
        
    //hashable
}

extension Persistable {
    
    /// Function designed for sensible saving persistable into core data, for instance if you don't wa
    ///
    /// - Parameter entity: <#entity description#>
    public func softUpdate(_ entity: T) {
        print("WARNING: THIS FUNCTION WANT IMPLEMENTED")
    }
}

extension Persistable {
    
    static var entityName: String {
        get {
            return String(describing: type(of: self)).components(separatedBy: ".").first!
        }
    }
    
}

extension Persistable {
    var hashValue: Int { return self.identity.hashValue }
}

