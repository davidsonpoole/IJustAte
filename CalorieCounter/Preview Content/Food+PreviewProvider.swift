//
//  Food+PreviewProvider.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import Foundation
import CoreData

extension FoodEntity {
    static var example: FoodEntity {
        let context = CoreDataViewModel.preview.container.viewContext
        let fetchRequest: NSFetchRequest<FoodEntity> = FoodEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        let results = try? context.fetch(fetchRequest)
        return (results?.first!)!
    }
}
