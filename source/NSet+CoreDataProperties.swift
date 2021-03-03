//
//  NSet+CoreDataProperties.swift
//  nWorkout
//
//  Created by Nathan Lanza on 3/2/21.
//
//

import Foundation
import CoreData


extension NSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSet> {
        return NSFetchRequest<NSet>(entityName: "NSet")
    }

    @NSManaged public var completedReps: Int64
    @NSManaged public var completedWeight: Double
    @NSManaged public var isWarmup: Bool
    @NSManaged public var note: String?
    @NSManaged public var reps: Int64
    @NSManaged public var weight: Double
    @NSManaged public var index: Int64
    @NSManaged public var lift: NLift?

}

extension NSet : Identifiable {

}
