//
//  AddLog.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI
import CoreData

struct AddLog: View {
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    
    @Binding var isAddLogActive: Bool
    @State private var foodSelection = Set<Food>()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Food.name, ascending: true)],
        animation: .default)
    private var foods: FetchedResults<Food>
    
    var body: some View {
        Text("What foods would you like to add?")
        NavigationView {
            List(foods, id: \.self, selection: $foodSelection) {
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
                    let newLog = Log(context: viewContext)
                    newLog.timestamp = Date()
                    newLog.foods = foodSelection as NSSet
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Error entering new log \(nsError), \(nsError.userInfo)")
                    }
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
