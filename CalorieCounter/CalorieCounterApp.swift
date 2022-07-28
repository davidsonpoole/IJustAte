//
//  CalorieCounterApp.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 6/17/22.
//

import SwiftUI

@main
struct CalorieCounterApp: App {
//    let router = AppRouter()
    @StateObject var viewModel: CoreDataViewModel = CoreDataViewModel.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
