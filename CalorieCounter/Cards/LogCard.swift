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
        VStack {
            Text("\(logFormatter.string(from: log.timestamp!))")
            if let foods = log.foods?.allObjects as? [Food] {
                ForEach(foods) { food in
                    Text("\(food.name!)")
                }
            }
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
