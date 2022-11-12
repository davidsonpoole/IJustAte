//
//  ViewLog.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI

struct LogDetailView: View {
    @EnvironmentObject var model: IJustAteViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(model.foods.map{$0.food}) { food in
                    NavigationLink(destination: FoodDetailView(food: food)) {
                        HStack {
                            Text(food.name)
                            Spacer()
                            Text(String.formatDouble(food.cal))
                                .padding([.trailing], 20)
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            Divider()
            Totals()
                .padding()
            Divider()
        }
    }
    
    func delete(at offsets: IndexSet) {
        model.deleteFoodFromLog(offset: offsets.first!)
    }
}

struct Totals: View {
    @EnvironmentObject var model: IJustAteViewModel
    
    var body: some View {
        let log: LogEntity? = model.log
        HStack(alignment: .top) {
            Text("Totals")
                .font(.bold(.largeTitle)())
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("**calories**: ")
                    Text("**carbohydrates**: ")
                    Text("**protein**: ")
                    Text("**fat**: ")
                }
                .frame(maxHeight: .infinity, alignment: .topLeading)
                VStack(alignment: .trailing) {
                    let totals = log?.totals ?? Macro.empty
                    Text(String.formatDouble(totals.cal))
                    Text(String.formatDouble(totals.car))
                    Text(String.formatDouble(totals.pro))
                    Text(String.formatDouble(totals.fat))
                }
                .frame(maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .frame(height: 70)
    }
    
}

//struct ViewLog_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewLog()
//    }
//}
