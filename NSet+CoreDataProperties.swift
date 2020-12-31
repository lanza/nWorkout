//
//  NSet+CoreDataProperties.swift
//  nWorkout
//
//  Created by Nathan Lanza on 12/31/20.
//  Copyright © 2020 Nathan Lanza. All rights reserved.
//
//

import Foundation
import CoreData


extension NSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSet> {
        return NSFetchRequest<NSet>(entityName: "NSet")
    }

    @NSManaged public var note: String?
    @NSManaged public var weight: Double
    @NSManaged public var completedWeight: Double
    @NSManaged public var reps: Int64
    @NSManaged public var completedReps: Int64
    @NSManaged public var id: UUID?
    @NSManaged public var lift: NLift?

}

extension NSet : Identifiable {

}
