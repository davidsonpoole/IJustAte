//
//  FoodEntity.swift
//  IJustAte
//
//  Created by Davidson Poole on 11/4/22.
//
//

import Foundation
import CoreData

public class FoodEntity: NSManagedObject, Encodable, Identifiable {

    @NSManaged public var cal: Double
    @NSManaged public var car: Double
    @NSManaged public var fat: Double
    @NSManaged public var id: Int16
    @NSManaged public var name: String
    @NSManaged public var pro: Double
    @NSManaged public var local: Bool
    @NSManaged public var loggedFoods: NSSet
    
    var macro: Macro {
        return Macro(cal: cal, car: car, pro: pro, fat: fat)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(cal, forKey: .cal)
        try container.encode(fat, forKey: .fat)
        try container.encode(car, forKey: .car)
        try container.encode(pro, forKey: .pro)
    }
    
    enum CodingKeys: CodingKey {
        case id, name, cal, fat, car, pro
    }
}

// MARK: Fetch Requests
extension FoodEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodEntity> {
        return NSFetchRequest<FoodEntity>(entityName: "FoodEntity")
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "name", ascending: true)]
    }
    
    static func allFoodsFetchRequest() -> NSFetchRequest<FoodEntity> {
        let request = fetchRequest()
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
    
    static func nameEqualsPredicate(name: String) -> NSPredicate {
        return NSPredicate(format: "name == %@", argumentArray: [name])
    }
    
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

struct Macro {
    var cal: Double
    var car: Double
    var pro: Double
    var fat: Double
    
    static var empty = Self.init(cal: 0, car: 0, pro: 0, fat: 0)
    
    static func + (a: Macro, b: Macro) -> Macro {
        Macro(cal: a.cal + b.cal, car: a.car + b.car, pro: a.pro + b.pro, fat: a.fat + b.fat)
    }
    
    static func - (a: Macro, b: Macro) -> Macro {
        Macro(cal: a.cal - b.cal, car: a.car - b.car, pro: a.pro - b.pro, fat: a.fat - b.fat)
    }
}

