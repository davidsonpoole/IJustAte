//
//  LogEntity.swift
//  IJustAte
//
//  Created by Davidson Poole on 11/6/22.
//
//

import Foundation
import CoreData

@objc(LogEntity)
public class LogEntity: NSManagedObject, Identifiable {

    @NSManaged public var timestamp: Date
    @NSManaged public var foods: NSSet
    
    var foodArr: [LoggedFoodEntity] {
        return foods.allObjects as? [LoggedFoodEntity] ?? [LoggedFoodEntity]()
    }
    
    var totals: Macro {
        let total = foodArr.map{$0.food}.reduce(Macro.empty) { $0 + $1.macro }
        print("getting totals. Total calories is \(total.cal)")
        return total
    }
    
}

// MARK: Fetch Requests
extension LogEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LogEntity> {
        return NSFetchRequest<LogEntity>(entityName: "LogEntity")
    }
    
    static func dayOfPredicate(date: Date) -> NSPredicate {
        return NSPredicate(format: "timestamp BETWEEN {%@, %@}", argumentArray: [Calendar.current.startOfDay(for: date) as CVarArg, Calendar.current.startOfDay(for: date.dayAfter) as CVarArg])
    }
}

// MARK: Generated accessors for foods
extension LogEntity {

    @objc(addFoodsObject:)
    @NSManaged public func addToFoods(_ value: LoggedFoodEntity)

    @objc(removeFoodsObject:)
    @NSManaged public func removeFromFoods(_ value: LoggedFoodEntity)

    @objc(addFoods:)
    @NSManaged public func addToFoods(_ values: NSSet)

    @objc(removeFoods:)
    @NSManaged public func removeFromFoods(_ values: NSSet)

}
