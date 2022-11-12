//
//  LogCardList.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/28/22.
//

import SwiftUI

struct SwipableLogContainer: View {
    @EnvironmentObject var model: IJustAteViewModel
    
    var body: some View {
        VStack {
            LogCard()
            HStack {
                CustomButton(opacity: 0.7) {
                    Image(systemName: "arrow.left")
                        .padding()
                        .frame(maxWidth: 50, maxHeight: 50)
                        .background(.gray)
                        .cornerRadius(50)
                        .onTapGesture {
                            model.changeDate(to: model.date.dayBefore)
                        }
                }
                CustomButton(opacity: 0.7) {
                    Image(systemName: "arrow.right")
                        .padding()
                        .frame(maxWidth: 50, maxHeight: 50)
                        .background(.gray)
                        .cornerRadius(50)
                        .onTapGesture {
                            if (!model.date.isToday()) {
                                model.changeDate(to: model.date.dayAfter)
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
