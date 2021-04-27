//
//  ApiClient.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation

class APIService {
  private let decoder = JSONDecoder()

    func performHTTPRequest(request: [String], completion: @escaping (Data, String, String) -> Void ) {
        for endpoint in request {
            guard let url = URL(string: endpoint) else { return }
            let urlSession = URLSession.shared
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error with: \(error.localizedDescription)")
                    return
                }
                guard let data = data else { return }
                guard let response = response else { return }
                guard let responseURL = response.url?.absoluteString else { return }
                guard let responseCategory = response.suggestedFilename else { return }
                completion(data, responseURL, responseCategory)

            }
            task.resume()
        }
    }
    
    func parseMovieResponse(data: Data) -> MovieResponse {
        return try! decoder.decode(MovieResponse.self, from: data)
    }

    func parsePersonResponse(data: Data) -> PersonResponse {
        return try! decoder.decode(PersonResponse.self, from: data)
    }
}

