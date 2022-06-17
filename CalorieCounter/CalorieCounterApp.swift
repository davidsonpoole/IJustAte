//
//  CalorieCounterApp.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 6/17/22.
//

import SwiftUI

@main
struct CalorieCounterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
