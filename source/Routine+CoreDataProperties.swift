//
//  Routine+CoreDataProperties.swift
//  nWorkout
//
//  Created by Nathan Lanza on 12/31/20.
//  Copyright © 2020 Nathan Lanza. All rights reserved.
//
//

import CoreData
import Foundation

extension Routine {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<Routine> {
    return NSFetchRequest<Routine>(entityName: "Routine")
  }

  @NSManaged public var id: UUID?

}

extension Routine: Identifiable {

}
