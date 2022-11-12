//
//  LogCard.swift
//  IJustAte
//
//  Created by Davidson Poole on 11/6/22.
//

import SwiftUI

struct LogCard: View {
    @State private var isFoodListActive = false
    @EnvironmentObject private var model: IJustAteViewModel
    
    var body: some View {
        VStack {
            Spacer()
            let selectedLog = model.log
//            let food = model.log?.foodArr.map { $0.food }.first
            //Text("\(food?.cal ?? 0)")
            if (selectedLog?.foods.count ?? 0 > 0) {
                LogDetailView()
            } else {
                Text("No log for " + (model.date.isToday() ? "today" : "this day") + " yet")
                    .padding(.bottom, 50)
            }
            NavigationLink(destination: FoodList(active: $isFoodListActive, log: selectedLog), isActive: $isFoodListActive) {
                Text("Add Food")
                    .padding()
                    .background(.green)
                    .cornerRadius(10)
                    .foregroundColor(.black)
            }
        }
    }
}
