//
//  DateUtils.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 7/28/22.
//

import Foundation

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func isToday() -> Bool {
        return Date().get(.day) == self.get(.day)
    }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
}

extension String {
    static func formatDouble(_ double: Double) -> String {
        if (floor(double) == double) {
            return String(Int(double))
        } else {
            return String(format: "%.1f", double)
        }
    }
}

extension URLSession {
    func fetchData<T: Decodable>(for url: URL, decoder: JSONDecoder, completion: @escaping (Result<T, Error>) -> Void) {
        self.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }

            if let data = data {
                do {
                    let object = try decoder.decode(T.self, from: data)
                    completion(.success(object))
                } catch let decoderError {
                    completion(.failure(decoderError))
                }
            }
        }.resume()
    }
}
