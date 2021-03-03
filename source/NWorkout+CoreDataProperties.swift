//
//  NWorkout+CoreDataProperties.swift
//  nWorkout
//
//  Created by Nathan Lanza on 3/2/21.
//
//

import Foundation
import CoreData


extension NWorkout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NWorkout> {
        return NSFetchRequest<NWorkout>(entityName: "NWorkout")
    }

    @NSManaged public var finishDate: Date?
    @NSManaged public var isComplete: Bool
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var lifts: NSSet?

}

// MARK: Generated accessors for lifts
extension NWorkout {

    @objc(addLiftsObject:)
    @NSManaged public func addToLifts(_ value: NLift)

    @objc(removeLiftsObject:)
    @NSManaged public func removeFromLifts(_ value: NLift)

    @objc(addLifts:)
    @NSManaged public func addToLifts(_ values: NSSet)

    @objc(removeLifts:)
    @NSManaged public func removeFromLifts(_ values: NSSet)

}

extension NWorkout : Identifiable {

}
