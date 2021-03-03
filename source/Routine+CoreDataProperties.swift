//
//  Routine+CoreDataProperties.swift
//  nWorkout
//
//  Created by Nathan Lanza on 3/2/21.
//
//

import Foundation
import CoreData


extension Routine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Routine> {
        return NSFetchRequest<Routine>(entityName: "Routine")
    }


}

extension Routine : Identifiable {

}
