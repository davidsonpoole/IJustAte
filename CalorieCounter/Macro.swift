//
//  Macro.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/14/22.
//

import Foundation

struct Macro {
    var cal: Int
    var car: Int
    var pro: Int
    var fat: Int
    
    static var empty = Self.init(cal: 0, car: 0, pro: 0, fat: 0)
    
    static func + (a: Macro, b: Macro) -> Macro {
        Macro(cal: a.cal + b.cal, car: a.car + b.car, pro: a.pro + b.pro, fat: a.fat + b.fat)
    }
    
    static func - (a: Macro, b: Macro) -> Macro {
        Macro(cal: a.cal - b.cal, car: a.car - b.car, pro: a.pro - b.pro, fat: a.fat - b.fat)
    }
}

extension LogEntity {
    var foodArr: [FoodEntity] {
        return foods?.allObjects as? [FoodEntity] ?? [FoodEntity]()
    }
    
    var totals: Macro {
        foodArr.reduce(Macro.empty) { $0 + $1.macro }
    }
}

extension FoodEntity {
    var macro: Macro {
        return Macro(cal: Int(cal), car: Int(car), pro: Int(pro), fat: Int(fat))
    }
}
