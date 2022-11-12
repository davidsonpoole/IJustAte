//
//  ServerUpdateMessage.swift
//  IJustAte
//
//  Created by Davidson Poole on 11/10/22.
//

import Foundation

struct ServerUpdateMessage: Decodable {
    var foods: [NewFoodRequest]
    var timestamp: String
}

struct NewFoodRequest: Decodable {
    var id: Int16
    var name: String
    var cal: Double
    var car: Double
    var fat: Double
    var pro: Double
}
