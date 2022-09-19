//
//  AddFood.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI
import CoreData

struct AddFoodView: View {
    @EnvironmentObject private var viewModel: CoreDataViewModel
    
    @Binding var isAddFoodActive: Bool
    @State private var name: String = ""
    @State private var cal: String = ""
    @State private var pro: String = ""
    @State private var car: String = ""
    @State private var fat: String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Add Food")
                .font(.largeTitle)
                .padding()
            CustomTextField(name: "Food", input: $name)
            CustomTextField(name: "Calories", input: $cal)
            CustomTextField(name: "Protein", input: $pro)
            CustomTextField(name: "Carbs", input: $car)
            CustomTextField(name: "Fat", input: $fat)
            Spacer()
            Text("Enter")
                .padding()
                .background(.green)
                .cornerRadius(10)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
                .onTapGesture {
                    if validateFood() {
                        // send food to database
                        withAnimation {
                            viewModel.createFood(
                                    name: name,
                                    cal: Double(cal) ?? 0,
                                    car: Double(car) ?? 0,
                                    pro: Double(pro) ?? 0,
                                    fat: Double(fat) ?? 0
                                    )
                        }
                        isAddFoodActive = false
                    } else {
                        // send error
                    }
                }
        }
    }
    
    private func validateFood() -> Bool {
        // validate each parameter
        return true
    }
}

struct CustomTextField: View {
    @State var name: String
    var input: Binding<String>
    var body: some View {
        TextField(name, text: input)
            .padding()
            .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.black, lineWidth: 0.5)
            )
            .padding([.trailing, .leading], 10)
            .padding([.top, .bottom], 5)
    }
}
//
//struct AddFood_Previews: PreviewProvider {
//    static var previews: some View {
//        AddFood()
//    }
//}
