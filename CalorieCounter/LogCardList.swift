//
//  LogCardList.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/28/22.
//

import SwiftUI

struct LogCardList: View {
    @Binding var todayPresent: Bool
    @EnvironmentObject private var viewModel: CoreDataViewModel
    
    @State private var selectedLog: LogEntity? = nil
    @State private var day = Date()
    var body: some View {
        VStack {
            Text(verbatim: "\(day.get(.month))/\(day.get(.day))/\(day.get(.year))")
                .font(.title)
            Spacer()
            let selectedLog = viewModel.logs.last(where: {$0.timestamp!.get(.day) == day.get(.day)})
            if day.isToday() {
                if selectedLog != nil {
                    ViewLog(log: selectedLog!)
                        .onAppear {
                            todayPresent = true
                        }
                } else {
                    Text("No log for today yet")
                        .padding(.bottom, 50)
                }
            } else {
                if selectedLog != nil {
                    ViewLog(log: selectedLog!)
                } else {
                    Text("No log for this day")
                        .padding(.bottom, 50)
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
