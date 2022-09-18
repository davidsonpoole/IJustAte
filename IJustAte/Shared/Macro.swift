//
//  Macro.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/14/22.
//

import Foundation

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

extension LogEntity {
    var foodArr: [LoggedFoodEntity] {
        return foods?.allObjects as? [LoggedFoodEntity] ?? [LoggedFoodEntity]()
    }
    
    var totals: Macro {
        return foodArr.reduce(Macro.empty) { $0 + $1.food!.macro }
    }
}

extension FoodEntity {
    var macro: Macro {
        return Macro(cal: cal, car: car, pro: pro, fat: fat)
    }
}
