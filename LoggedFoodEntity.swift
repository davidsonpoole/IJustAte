//
//  LoggedFoodEntity.swift
//  IJustAte
//
//  Created by Davidson Poole on 11/6/22.
//
//

import Foundation
import CoreData

@objc(LoggedFoodEntity)
public class LoggedFoodEntity: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoggedFoodEntity> {
        return NSFetchRequest<LoggedFoodEntity>(entityName: "LoggedFoodEntity")
    }

    @NSManaged public var timestamp: Date
    @NSManaged public var food: FoodEntity
    @NSManaged public var log: LogEntity
}
