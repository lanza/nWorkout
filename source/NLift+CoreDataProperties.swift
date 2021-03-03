//
//  NLift+CoreDataProperties.swift
//  nWorkout
//
//  Created by Nathan Lanza on 3/2/21.
//
//

import CoreData
import Foundation

extension NLift {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<NLift> {
    return NSFetchRequest<NLift>(entityName: "NLift")
  }

  @NSManaged public var note: String?
  @NSManaged public var index: Int64
  @NSManaged public var next: NLift?
  @NSManaged public var previous: NLift?
  @NSManaged public var sets: NSSet?
  @NSManaged public var type: LiftType?
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

extension NLift: Identifiable {

}
