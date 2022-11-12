//
//  AddLog.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI
import CoreData
import Intents

struct FoodList: View {
    @EnvironmentObject var model: IJustAteViewModel
    
    @Binding var active: Bool
    var log: LogEntity?
    
    @FetchRequest(fetchRequest: FoodEntity.allFoodsFetchRequest())
    private var foods: FetchedResults<FoodEntity>
    
    @State private var showSuccess = false
    @State private var searchText = ""
    @State private var isNewFoodActive = false
    
    var body: some View {
        Text("What foods would you like to add?")
        ZStack {
            List {
                ForEach(searchResults, id: \.self) { item in
                    ListItem(text: item.name) {
                        model.appendFoodToLog(food: item)
                        showSuccess = true
                    }
                }
            }
            .searchable(text: $searchText)
            .toolbar {
                NavigationLink(destination: NewFoodView(isNewFoodActive: $isNewFoodActive), isActive: $isNewFoodActive) {
                    Image(systemName: "plus")
                        .padding(.trailing, 5)
                }
            }
            SuccessPopup(active: $showSuccess)
                .zIndex(1) // to fix a bug with easeOut
        }
    }
    
    struct ListItem: View {
        var text: String?
        var onTap: () -> Void
        
        @State private var isPressed = false
        
        var body: some View {
            Text(text ?? "")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .background(.white)
                .onTapGesture {
                    onTap()
                }
        }
    }
    
    var searchResults: [FoodEntity] {
        if searchText.isEmpty {
            return foods.map{ $0 }
        } else {
            return foods.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    struct SuccessPopup: View {
        @Binding var active: Bool
        var body: some View {
            if (active) {
                HStack {
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Food Successfully Added")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: 100)
                .background(.gray)
                .opacity(0.6)
                .cornerRadius(10)
                .padding()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.1, execute: {
                        withAnimation(.easeOut(duration: 0.1)) {
                            active = false
                        }
                    })
                }
                .transition(.opacity)
                
            }
        }
    }
}
//
//struct FoodListBinding_Preview: View {
//    @State private var value = false
//    var body: some View {
//        FoodList(active: $value)
//    }
//}
//
//struct FoodList_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodListBinding_Preview()
//    }
//}
