//
//  IJustAteProps.swift
//  IJustAte
//
//  Created by Davidson Poole on 11/6/22.
//

import Foundation

struct IJustAteProps {
    static let localIP = "http://REDACTED_LOCAL_IP/"
    static let externalIP = "http://REDACTED_EXTERNAL_IP/"
}

extension UserDefaults {
    enum Keys: String, CaseIterable {
        case lastFoodId
        case lastTimestamp
    }
    
    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }
}
