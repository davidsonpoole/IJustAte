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
    var reset: Bool
}

struct NewFoodRequest: Decodable {
    var id: Int32
    var name: String
    var cal: Double
    var car: Double
    var fat: Double
    var pro: Double
}
