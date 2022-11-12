//
//  PersistentContainer.swift
//  IJustAte
//
//  Created by Davidson Poole on 9/13/22.
//

import Foundation
import CoreData

final class PersistentContainer: NSPersistentContainer {
    static let shared = PersistentContainer(name: "IJustAte")
    
    private var persistentHistoryObserver: PersistentHistoryObserver?
    
    func setup() {
        // Get shared database for app group
        let storeURL = URL.storeURL(for: "group.com.davidsonpoole.ijustate", databaseName: "IJustAte")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        persistentStoreDescriptions = [storeDescription]
        
        loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Error loading Core Data. \(error)")
            } else {
                print("Successfully loaded Core Data")
            }
        })
        
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        persistentHistoryObserver = startObservingPersistentHistoryTransactions()
    }
    
    func startObservingPersistentHistoryTransactions() -> PersistentHistoryObserver {
        let observer = PersistentHistoryObserver(target: .app, persistentContainer: self, userDefaults: .standard)

        viewContext.name = "view_context"
        viewContext.transactionAuthor = "main_app_view_context"

        observer.startObserving()
        return observer
    }
    
    override func newBackgroundContext() -> NSManagedObjectContext {
        let context = super.newBackgroundContext()
        context.name = "background_context"
        context.transactionAuthor = "main_app_background_context"
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
    }
}

extension NSManagedObjectContext {
    func saveIfChanged() -> Void {
        guard hasChanges else { return }
        do {
            try save()
            print("saved data")
            return
        } catch {
            print("Error saving data. \(error)")
        }
    }
}

public extension URL {
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }
        
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
