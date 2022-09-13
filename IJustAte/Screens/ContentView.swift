//
//  ContentView.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 6/17/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var authenticated = true
    @State private var user: UserEntity? = nil
    
    // authentication not currently used
    
    var body: some View {
        if (authenticated) {
            HomeView(user: $user)
        } else {
            LoginView(authenticated: $authenticated, user: $user)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, CoreDataViewModel.preview.container.viewContext)
    }
}
