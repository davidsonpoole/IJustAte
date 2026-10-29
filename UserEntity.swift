//
//  UserEntity.swift
//  IJustAte
//
//  Created by Davidson Poole on 11/6/22.
//
//

import Foundation
import CoreData

public class UserEntity: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var username: String?
    @NSManaged public var goal: GoalEntity?
    
    static var example: UserEntity {
        let context = IJustAteViewModel.preview.container.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        let results = try? context.fetch(fetchRequest)
        return (results?.first!)!
    }
}
