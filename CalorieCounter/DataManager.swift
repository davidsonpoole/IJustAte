//
//  DataManager.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/15/22.
//

import Foundation
import CoreData

struct DataManager {
    static func saveLogs(viewContext: NSManagedObjectContext) {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Error saving logs \(nsError), \(nsError.userInfo)")
        }
    }
}
