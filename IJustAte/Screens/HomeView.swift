//
//  HomeView.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/15/22.
//

import SwiftUI

struct HomeView: View {
    @Binding var user: UserEntity?
    @State private var isAddFoodActive = false
    @State var refresh = UUID()
    @EnvironmentObject private var viewModel: CoreDataViewModel
    
//    var didRemoteChange = NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange).receive(on: DispatchQueue.main)
    
    var body: some View {
        NavigationView {
            LogCardList()
                .padding([.bottom], 20)
//                .onReceive(self.didRemoteChange, perform: { _ in
//                    print("Received notification")
//                    viewModel.reloadContainer()
//                    self.refresh = UUID()
//                })
            .toolbar {
                NavigationLink(destination: AddFood(isAddFoodActive: $isAddFoodActive), isActive: $isAddFoodActive) {
                    Text("Add food")
                }
            }
            .navigationTitle("Calorie Counter")
        }
        .navigationViewStyle(.stack)
    }
}

struct HomeView_PreviewHelper: View {
    @State private var user: UserEntity? = UserEntity.example
    var body: some View {
        HomeView(user: $user)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView_PreviewHelper().environmentObject(CoreDataViewModel.preview)
    }
}
