//
//  HomeView.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/15/22.
//

import SwiftUI

struct HomeView: View {
    @Binding var user: UserEntity?
    @State private var date = Date()
    @EnvironmentObject var model: IJustAteViewModel
    
    var body: some View {
        NavigationView {
            SwipableLogContainer()
                .padding([.bottom], 20)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("IJustAte")
                            .font(.system(size: 50, weight: .bold))
                        Spacer()
                        let date = model.date
                        Text(verbatim: "\(date.get(.month))/\(date.get(.day))/\(date.get(.year))")
                            .font(.title)
                    }
                }
            }
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
