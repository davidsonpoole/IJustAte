//
//  Log+PreviewProvider.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import Foundation
import CoreData

extension LogEntity {
    static var example: LogEntity {
        let context = IJustAteViewModel.preview.container.viewContext
        let fetchRequest: NSFetchRequest<LogEntity> = LogEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        let results = try? context.fetch(fetchRequest)
        return (results?.first!)!
    }
    
    static var examples: [LogEntity] {
        let context = IJustAteViewModel.preview.container.viewContext
        let fetchRequest: NSFetchRequest<LogEntity> = LogEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        let results = try? context.fetch(fetchRequest)
        return results!
    }
}
