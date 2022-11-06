//
//  FoodFetcher.swift
//  IJustAte
//
//  Created by Davidson Poole on 11/4/22.
//

import Foundation

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




