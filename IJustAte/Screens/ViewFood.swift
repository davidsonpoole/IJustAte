//
//  ViewFood.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI

struct ViewFood: View {
    var food: FoodEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Food: \(food.name!)")
                .font(.largeTitle)
            Spacer().frame(maxHeight: 200)
            Text("\(String.formatDouble(food.cal)) calories")
            Text("\(String.formatDouble(food.pro))g protein")
            Text("\(String.formatDouble(food.fat))g fat")
            Text("\(String.formatDouble(food.car))g carbohydrates")
        }
        .font(.title)
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

//struct ViewFood_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewFood()
//    }
//}
