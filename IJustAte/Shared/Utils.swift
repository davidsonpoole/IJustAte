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
        // Compares the whole date. Comparing only .day made any 28th read as
        // "today" on the 28th of any month or year.
        return Calendar.current.isDateInToday(self)
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
    
    func convertToDouble() -> Double {
        guard let double = Double(self), double > 0 else {
            return 0
        }
        
        return double
    }
}

extension URLSession {
    func fetchData<T: Decodable>(for url: URL, decoder: JSONDecoder, completion: @escaping (Result<T, Error>) -> Void) {
        self.dataTask(with: url) { (data, response, error) in
            // Each path must return: the error branch used to fall through to
            // the data branch and call completion twice.
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            do {
                let object = try decoder.decode(T.self, from: data)
                completion(.success(object))
            } catch let decoderError {
                completion(.failure(decoderError))
            }
        }.resume()
    }
}
