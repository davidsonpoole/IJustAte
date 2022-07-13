//
//  ViewFood.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI

struct ViewFood: View {
    var food: Food
    
    var body: some View {
        FoodCard(food: food)
    }
}

//struct ViewFood_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewFood()
//    }
//}
