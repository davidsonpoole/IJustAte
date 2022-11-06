//
//  FoodEntity+CoreDataClass.swift
//  IJustAte
//
//  Created by Davidson Poole on 11/4/22.
//
//

import Foundation
import CoreData

enum CoderConfigurationError: Error {
    case missingManagedObjectContext
}

public class FoodEntity: NSManagedObject, Codable {
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw CoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int16.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.cal = try container.decode(Double.self, forKey: .cal)
        self.fat = try container.decode(Double.self, forKey: .fat)
        self.car = try container.decode(Double.self, forKey: .car)
        self.pro = try container.decode(Double.self, forKey: .pro)
        self.modified = try container.decode(String.self, forKey: .modified)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(cal, forKey: .cal)
        try container.encode(fat, forKey: .fat)
        try container.encode(car, forKey: .car)
        try container.encode(pro, forKey: .pro)
    }
    
    enum CodingKeys: CodingKey {
        case id, name, cal, fat, car, pro, modified
    }
    
    var modified: String?
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
