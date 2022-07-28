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
        VStack(alignment: .leading) {
            Text("Food: \(food.name!)")
                .font(.largeTitle)
            Spacer().frame(maxHeight: 200)
            Text("\(food.cal) calories")
            Text("\(food.pro)g protein")
            Text("\(food.fat)g fat")
            Text("\(food.car)g carbohydrates")
        }
        .font(.title)
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct FoodCard_Previews: PreviewProvider {
    static var previews: some View {
        FoodCard(food: Food.example)
    }
}
