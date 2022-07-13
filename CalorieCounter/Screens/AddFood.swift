//
//  AddFood.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI
import CoreData

struct AddFood: View {
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    
    @Binding var isAddFoodActive: Bool
    @State private var name: String = ""
    @State private var cal: String = ""
    @State private var pro: String = ""
    @State private var car: String = ""
    @State private var fat: String = ""
    var body: some View {
        TextField("Food", text: $name)
            .padding()
            .border(.black)
        TextField("Calories", text: $cal)
        TextField("Protein", text: $pro)
        TextField("Carbs", text: $car)
        TextField("Fat", text: $fat)
        Spacer()
        Text("Enter")
            .onTapGesture {
                if validateFood() {
                    // send food to database
                    withAnimation {
                        let newFood = Food(context: viewContext)
                        newFood.name = name
                        newFood.cal = Int16(cal) ?? 0
                        newFood.pro = Int16(pro) ?? 0
                        newFood.car = Int16(car) ?? 0
                        newFood.fat = Int16(fat) ?? 0
            
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Error saving food \(nsError), \(nsError.userInfo)")
                        }
                    }
                    isAddFoodActive = false
                } else {
                    // send error
                }
            }
    }
    
    private func validateFood() -> Bool {
        // validate each parameter
        return true
    }
}
//
//struct AddFood_Previews: PreviewProvider {
//    static var previews: some View {
//        AddFood()
//    }
//}
