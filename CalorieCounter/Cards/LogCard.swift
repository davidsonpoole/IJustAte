//
//  LogCard.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI

struct LogCard: View {
    var log: Log
    
    var body: some View {
            VStack {
                Text("\(logFormatter.string(from: log.timestamp!))")
            }
    }
}

func totals(_ foods: [Food]) -> Macro {
    var totalCal = 0
    var totalCar = 0
    var totalFat = 0
    var totalPro = 0
    guard foods.count > 0 else {return Macro.empty}
    for food in foods {
        totalCal += Int(food.cal)
        totalCar += Int(food.car)
        totalFat += Int(food.fat)
        totalPro += Int(food.pro)
    }
    return Macro(cal: totalCal, car: totalCar, pro: totalPro, fat: totalFat)
}

struct Macro {
    var cal: Int
    var car: Int
    var pro: Int
    var fat: Int
    
    static var empty = Self.init(cal: 0, car: 0, pro: 0, fat: 0)
}

struct LogCard_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LogCard(log: Log.example)
        }
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
