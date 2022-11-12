//
//  IJustAteApp.swift
//  IJustAte
//
//  Created by Davidson Poole on 6/17/22.
//

import SwiftUI
import Intents

@main
struct IJustAteApp: App {
    
    init() {
        UserDefaults.standard.register(defaults: [
            UserDefaults.Keys.lastFoodId.rawValue: 10000,
            UserDefaults.Keys.lastTimestamp.rawValue: ""
        ])
        
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(IJustAteViewModel.shared)
                .environment(\.managedObjectContext, IJustAteViewModel.shared.container.viewContext)
        }
    }
}
