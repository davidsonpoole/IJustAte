//
//  ContentView.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 6/17/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Log.timestamp, ascending: true)],
        animation: .default)
    private var logs: FetchedResults<Log>
    
    @State private var isAddFoodActive = false
    @State private var isAddLogActive = false
    private var router = Navigator()
    
    
    var body: some View {
        NavigationView {
            VStack {
//                if let todaysLog = logs.first(where: {$0.timestamp!.get(.day) == Date().get(.day)}) {
//                    Navigator.navigate(.viewLog(todaysLog)) {
//                        LogCard(log: todaysLog)
//                    }
//                }
//                Spacer()
                List {
                    ForEach(logs) { log in
                        Navigator.navigate(.viewLog(log)) {
                            LogCard(log: log)
                        }
                    }
                }
                HStack {
                    NavigationLink(
                        destination: router.view(for: .addFood($isAddFoodActive)),
                        isActive: $isAddFoodActive
                    ) {
                            Text("Add food")
                                .padding()
                                .background(.green)
                                .cornerRadius(10)
                                .foregroundColor(.black)
                        }
                    NavigationLink(
                        destination: router.view(for: .addLog($isAddLogActive)),
                        isActive: $isAddLogActive
                    ) {
                        Text("Add log")
                            .padding()
                            .background(.green)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationTitle("Today's Log")
        }
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
