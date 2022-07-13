//
//  FoodCard.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI

struct FoodCard: View {
    var food: Food
    var body: some View {
        VStack {
            Text("Food: \(food.name!)")
            Text("\(food.cal) calories")
            Text("\(food.pro)g protein")
            Text("\(food.fat)g fat")
            Text("\(food.car)g carbohydrates")
        }
    }
}

struct FoodCard_Previews: PreviewProvider {
    static var previews: some View {
        FoodCard(food: Food.example)
    }
}
