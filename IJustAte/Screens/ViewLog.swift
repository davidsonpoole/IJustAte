//
//  ViewLog.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI

struct ViewLog: View {
    @EnvironmentObject private var viewModel: CoreDataViewModel
    @ObservedObject var log: LogEntity
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(log.foodArr) { loggedFood in
                    let food = loggedFood.food!
                    NavigationLink(destination: ViewFood(food: food)) {
                        HStack {
                            Text(food.name!)
                            Spacer()
                            Text(String.formatDouble(food.cal))
                                .padding([.trailing], 20)
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            Divider()
            Totals(log.totals)
                .padding()
            Divider()
        }
    }
    
    func delete(at offsets: IndexSet) {
        let loggedFood = log.foodArr[offsets.first!]
        viewModel.container.viewContext.delete(loggedFood)
        viewModel.saveData()
    }
}

struct Totals: View {
    private var totals: Macro
    
    init(_ totals: Macro) { self.totals = totals }
    
    var body: some View {
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
