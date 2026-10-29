//
//  IJustAteProps.swift
//  IJustAte
//
//  Created by Davidson Poole on 11/6/22.
//

import Foundation

// The server address lives in ServerConfig.swift, which is untracked.
// See ServerConfig.example.swift to set up a fresh clone.
struct IJustAteProps {
    static let baseURL = ServerConfig.baseURL;
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
