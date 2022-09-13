//
//  User+PreviewProvider.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/15/22.
//

import Foundation
import CoreData

extension UserEntity {
    static var example: UserEntity {
        let context = CoreDataViewModel.preview.container.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        let results = try? context.fetch(fetchRequest)
        return (results?.first!)!
    }
}
