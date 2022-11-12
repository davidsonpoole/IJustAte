//
//  GoalEntity.swift
//  IJustAte
//
//  Created by Davidson Poole on 11/6/22.
//
//

import Foundation
import CoreData

@objc(GoalEntity)
public class GoalEntity: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoalEntity> {
        return NSFetchRequest<GoalEntity>(entityName: "GoalEntity")
    }

    @NSManaged public var cal: Int16
    @NSManaged public var car: Int16
    @NSManaged public var fat: Int16
    @NSManaged public var pro: Int16
    @NSManaged public var user: UserEntity
}
