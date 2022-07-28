//
//  AddLog.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI
import CoreData

struct AddLog: View {
    @EnvironmentObject private var viewModel: CoreDataViewModel
    
    @Binding var isAddLogActive: Bool
    @State private var foodSelection = Set<FoodEntity>()
    
    var body: some View {
        Text("What foods would you like to add?")
        NavigationView {
            List(viewModel.foods, id: \.self, selection: $foodSelection) {
                Text($0.name!)
            }
            .toolbar {
                EditButton()
            }
        }
        Text("Selected foods:")
        List(Array(foodSelection)) {
            Text($0.name!)
        }
        Spacer()
        HStack {
            Text("Enter")
                .onTapGesture {
                    viewModel.addLog(foods: foodSelection)
                    isAddLogActive = false
                }
        }
    }
}

struct AddLogBinding_Preview: View {
    @State private var value = false
    var body: some View {
        AddLog(isAddLogActive: $value)
    }
}

struct AddLog_Previews: PreviewProvider {
    static var previews: some View {
        AddLogBinding_Preview()
    }
}
