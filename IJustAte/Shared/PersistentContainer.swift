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
        
        viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
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
