//
//  ViewLog.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI

struct ViewLog: View {
    var log: Log
    
    var body: some View {
        VStack {
            Text(logFormatter.string(from: log.timestamp!))
//            if let foods = log.foods?.allObjects as? [Food] {
//                List {
//                    ForEach(foods) { food in
//                        Navigator.navigate(.viewFood(food)) {
//                            Text("\(food.name!)")
//                        }
//                    }
//                }
//            }
            if let foods = log.foods?.allObjects as? [Food] {
                List {
                    ForEach(foods) { food in
                        Navigator.navigate(.viewFood(food)) {
                            Text("\(food.name!)")
                        }
                    }
                }
                let totals = totals(foods)
                Text("Totals")
                Text("calories: \(totals.cal)")
                Text("carbohydrates: \(totals.car)")
                Text("protein: \(totals.pro)")
                Text("fat: \(totals.fat)")
            }
        }
    }
}

//struct ViewLog_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewLog()
//    }
//}
