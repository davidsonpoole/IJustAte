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
    @State private var isAddLogActive = false
    @State private var isTodayPresent = false
    private let router = Navigator()
    
    var body: some View {
        NavigationView {
            VStack {
                LogCardList(todayPresent: $isTodayPresent)
                    .padding([.bottom], 20)
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
                    if (!isTodayPresent) {
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
                    } else {
                        NavigationLink(
                            destination: router.view(for: .addLog($isAddLogActive)),
                            isActive: $isAddLogActive
                        ) {
                            Text("Update log")
                                .padding()
                                .background(.orange)
                                .cornerRadius(10)
                                .foregroundColor(.black)
                        }
                    }
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
        HomeView_PreviewHelper()
    }
}
