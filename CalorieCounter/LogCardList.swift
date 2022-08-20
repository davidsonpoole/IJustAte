//
//  LogCardList.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/28/22.
//

import SwiftUI

struct LogCardList: View {
    @EnvironmentObject private var viewModel: CoreDataViewModel
    
    @State private var selectedLog: LogEntity? = nil
    @State private var isAddLogActive = false
    @State private var day = Date()
    var body: some View {
        VStack {
            Text(verbatim: "\(day.get(.month))/\(day.get(.day))/\(day.get(.year))")
                .font(.title)
            Spacer()
            let selectedLog = viewModel.logs.last(where: {$0.timestamp!.get(.day) == day.get(.day)})
            if (selectedLog != nil && (selectedLog?.foods?.allObjects as! [FoodEntity]).count > 0) {
                ViewLog(log: selectedLog!)
                NavigationLink(destination: AddLog(isAddLogActive: $isAddLogActive, day: day), isActive: $isAddLogActive) {
                    Text("Edit log")
                        .padding()
                        .background(.orange)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                }
            } else {
                Text("No log for " + (day.isToday() ? "today" : "this day") + " yet")
                    .padding(.bottom, 50)
                NavigationLink(destination: AddLog(isAddLogActive: $isAddLogActive, day: day), isActive: $isAddLogActive) {
                    Text("Add log")
                        .padding()
                        .background(.green)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                }
            }
            HStack {
                Button(opacity: 0.7) {
                    Image(systemName: "arrow.left")
                        .padding()
                        .frame(maxWidth: 50, maxHeight: 50)
                        .background(.gray)
                        .cornerRadius(50)
                        .onTapGesture {
                            day = day.dayBefore
                        }
                }
                Button(opacity: 0.7) {
                    Image(systemName: "arrow.right")
                        .padding()
                        .frame(maxWidth: 50, maxHeight: 50)
                        .background(.gray)
                        .cornerRadius(50)
                        .onTapGesture {
                            if (!day.isToday()) {
                                day = day.dayAfter
                            }
                        }
                }
            }
        }
    }
}

//struct LogCardList_Previews: PreviewProvider {
//    static var previews: some View {
//        LogCardList()
//    }
//}
