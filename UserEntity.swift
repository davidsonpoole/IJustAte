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

    @NSManaged public var password: String?
    @NSManaged public var username: String?
    @NSManaged public var goal: GoalEntity?
}
