//
//  LogCard.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import SwiftUI

struct LogCard: View {
    var log: Log
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ViewLog(log: log)
                Spacer()
            }
            .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.7)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 2))
            .padding()
        }
    }
}

struct LogCard_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LogCard(log: Log.example)
        }
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
