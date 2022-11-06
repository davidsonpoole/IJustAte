//
//  AddLog.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI
import CoreData

struct AddLog: View {
    @EnvironmentObject private var viewModel: CoreDataViewModel
    
    @Binding var isAddLogActive: Bool
    var day: Date = Date()
    @State private var showSuccess = false
    @State private var searchText = ""
    
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
    
    var body: some View {
        Text("What foods would you like to add?")
        ZStack {
            List {
                ForEach(searchResults, id: \.self) { item in
                    ListItem(text: item.name) {
                        viewModel.addToLog(food: item)
                        showSuccess = true
                    }
                }
            }
            .searchable(text: $searchText)
            SuccessPopup(active: $showSuccess)
                .zIndex(1) // to fix a bug with easeOut
        }
    }
    
    var searchResults: [FoodEntity] {
        if searchText.isEmpty {
            return viewModel.foods
        } else {
            return viewModel.foods.filter { $0.name!.localizedCaseInsensitiveContains(searchText) }
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

struct AddLogBinding_Preview: View {
    @State private var value = false
    var body: some View {
        AddLog(isAddLogActive: $value)
    }
}

struct AddLog_Previews: PreviewProvider {
    static var previews: some View {
        AddLogBinding_Preview().environmentObject(CoreDataViewModel.preview)
    }
}
