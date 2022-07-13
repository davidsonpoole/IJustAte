//
//  DateFormatter.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/13/22.
//

import Foundation

let logFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
