//
//  NLift+CoreDataProperties.swift
//  nWorkout
//
//  Created by Nathan Lanza on 12/31/20.
//  Copyright © 2020 Nathan Lanza. All rights reserved.
//
//

import Foundation
import CoreData


extension NLift {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NLift> {
        return NSFetchRequest<NLift>(entityName: "NLift")
    }

    @NSManaged public var note: String?
    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var previous: NLift?
    @NSManaged public var sets: NSSet?
    @NSManaged public var workout: NWorkout?

}

// MARK: Generated accessors for sets
extension NLift {

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: NSet)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: NSet)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)

}

extension NLift : Identifiable {

}
