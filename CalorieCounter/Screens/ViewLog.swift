//
//  ViewLog.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI

struct ViewLog: View {
    var log: LogEntity
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(log.foodArr) { food in
                    Navigator.navigate(.viewFood(food)) {
                        HStack {
                            Text(food.name!)
                            Spacer()
                            Text("\(food.cal)")
                                .padding([.trailing], 20)
                        }
                    }
                }
            }
            Divider()
            Totals(log.totals)
                .padding()
            Divider()
        }
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
                    Text("\(totals.cal)")
                    Text("\(totals.car)")
                    Text("\(totals.pro)")
                    Text("\(totals.fat)")
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
