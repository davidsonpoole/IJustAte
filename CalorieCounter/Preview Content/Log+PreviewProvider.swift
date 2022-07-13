//
//  Log+PreviewProvider.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/12/22.
//

import Foundation
import CoreData

extension Log {
    static var example: Log {
        let context = PersistenceController.preview.container.viewContext
        let fetchRequest: NSFetchRequest<Log> = Log.fetchRequest()
        fetchRequest.fetchLimit = 1
        let results = try? context.fetch(fetchRequest)
        return (results?.first!)!
    }
}
