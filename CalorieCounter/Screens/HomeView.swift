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
    
    var body: some View {
        NavigationView {
            LogCardList()
                .padding([.bottom], 20)
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
