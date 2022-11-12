//
//  ViewFood.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI

struct FoodDetailView: View {
    var food: FoodEntity?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Food: \(food?.name ?? "")")
                .font(.largeTitle)
            Spacer().frame(maxHeight: 200)
            Text("\(String.formatDouble(food?.cal ?? 0)) calories")
            Text("\(String.formatDouble(food?.pro ?? 0))g protein")
            Text("\(String.formatDouble(food?.fat ?? 0))g fat")
            Text("\(String.formatDouble(food?.car ?? 0))g carbohydrates")
        }
        .font(.title)
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

//struct ViewFood_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodDetailView()
//    }
//}
