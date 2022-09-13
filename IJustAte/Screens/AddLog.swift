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
    var day: Date = Date()
    @State private var foodSelection = Set<FoodEntity>()
    
    var body: some View {
        Text("What foods would you like to add?")
        NavigationView {
            List(selection: $foodSelection) {
                ForEach(viewModel.foods, id: \.self) { item in
                    Text(item.name ?? "")
                }
            }
            .toolbar {
                EditButton()
            }
            .listStyle(.inset)
        }
        Spacer()
        HStack {
            Text("Enter")
                .padding()
                .background(.green)
                .cornerRadius(10)
                .foregroundColor(.black)
                .onTapGesture {
                    viewModel.updateLog(foods: foodSelection, date: day)
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
        AddLogBinding_Preview().environmentObject(CoreDataViewModel.preview)
    }
}
