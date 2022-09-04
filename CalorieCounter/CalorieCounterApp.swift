//
//  CalorieCounterApp.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 6/17/22.
//

import SwiftUI
import Intents

@main
struct CalorieCounterApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var viewModel: CoreDataViewModel = CoreDataViewModel.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
        .onChange(of: scenePhase) { phase in
            INPreferences.requestSiriAuthorization({status in
                // handle errors here
            })
        }
    }
}
