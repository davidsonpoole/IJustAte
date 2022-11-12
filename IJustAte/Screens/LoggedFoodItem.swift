//
//  LoggedFoodItem.swift
//  IJustAte
//
//  Created by Davidson Poole on 11/10/22.
//

import SwiftUI
import CoreData

enum MyError: Error {
    case runtimeError(String)
}

struct LoggedFoodItem: View {
    @ObservedObject var loggedFood: LoggedFoodEntity
    
    var body: some View {
        let food = loggedFood.food
        Text("\(food.cal)")
        NavigationLink(destination: FoodDetailView(food: loggedFood.food)) {
//            let food = loggedFood.food
//            Text("\(food.cal)")
            HStack {
                Text(loggedFood.food.name)
                Spacer()
                Text(String.formatDouble(loggedFood.food.cal))
                    .padding([.trailing], 20)
            }
        }
        .onAppear {
            print("re rendering LoggedFoodItem")
        }
    }
}
