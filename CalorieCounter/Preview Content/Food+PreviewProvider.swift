//
//  Food+PreviewProvider.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import Foundation
import CoreData

extension Food {
    static var example: Food {
        let context = PersistenceController.preview.container.viewContext
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        fetchRequest.fetchLimit = 1
        let results = try? context.fetch(fetchRequest)
        return (results?.first!)!
    }
}
