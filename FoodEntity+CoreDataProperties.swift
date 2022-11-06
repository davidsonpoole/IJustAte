//
//  FoodEntity+CoreDataProperties.swift
//  IJustAte
//
//  Created by Davidson Poole on 11/5/22.
//
//

import Foundation
import CoreData


extension FoodEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodEntity> {
        return NSFetchRequest<FoodEntity>(entityName: "FoodEntity")
    }

    @NSManaged public var cal: Double
    @NSManaged public var car: Double
    @NSManaged public var fat: Double
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var pro: Double
    @NSManaged public var local: Bool
    @NSManaged public var loggedFood: NSSet?

}

// MARK: Generated accessors for loggedFood
extension FoodEntity {

    @objc(addLoggedFoodObject:)
    @NSManaged public func addToLoggedFood(_ value: LoggedFoodEntity)

    @objc(removeLoggedFoodObject:)
    @NSManaged public func removeFromLoggedFood(_ value: LoggedFoodEntity)

    @objc(addLoggedFood:)
    @NSManaged public func addToLoggedFood(_ values: NSSet)

    @objc(removeLoggedFood:)
    @NSManaged public func removeFromLoggedFood(_ values: NSSet)

}

extension FoodEntity : Identifiable {

}
