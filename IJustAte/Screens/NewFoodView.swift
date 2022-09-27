//
//  AddFood.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI
import CoreData

struct NewFoodView: View {
    @EnvironmentObject private var viewModel: CoreDataViewModel
    private let DEBUG = true
    @State private var clearAllFoodsActive = false
    
    @Binding var isNewFoodActive: Bool
    @State private var name: String = ""
    @State private var cal: String = ""
    @State private var pro: String = ""
    @State private var car: String = ""
    @State private var fat: String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("New Food")
                .font(.largeTitle)
                .padding()
            CustomTextField(name: "Food", input: $name)
            CustomTextField(name: "Calories", numbersOnly: true, input: $cal)
            CustomTextField(name: "Protein", numbersOnly: true, input: $pro)
            CustomTextField(name: "Carbs", numbersOnly: true, input: $car)
            CustomTextField(name: "Fat", numbersOnly: true, input: $fat)
            Spacer()
            if (DEBUG) {
                HStack {
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
                                isNewFoodActive = false
                            } else {
                                // send error
                            }
                        }
                    Text("Clear Foods")
                        .padding()
                        .background(.red)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onTapGesture {
                            clearAllFoodsActive = true
                        }
                        .confirmationDialog("Are you sure you want to clear all foods?", isPresented: $clearAllFoodsActive) {
                            Button("Delete all foods", role: .destructive) {
                                viewModel.clearFoods()
                                viewModel.saveData()
                            }
                        }
                }
            } else {
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
                            isNewFoodActive = false
                        } else {
                            // send error
                        }
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
    let name: String
    var numbersOnly: Bool = false
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
            .keyboardType(numbersOnly ? .decimalPad : .default)
    }
}
//
//struct AddFood_Previews: PreviewProvider {
//    static var previews: some View {
//        AddFood()
//    }
//}
