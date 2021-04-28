//
//  MockApiService.swift
//  MovieWarehouseTests
//
//  Created by Kurs on 22/04/2021.
//

import Foundation
import XCTest
@testable import MovieWarehouse

class MockApiService: APIService {

    override func performHTTPRequest(request: [String], completion: @escaping (Data, String, String) -> Void) {
        for n in 0..<2 {
            let data = Data()
            var responseURL = ""
            let responseCategory = "top_rated"
            if n == 0 {
                responseURL = "/movie/"
            }
            completion(data, responseURL, responseCategory)
        }
    }

    override func parseMovieResponse(data: Data) -> MovieResponse {
        let movie = Movie(id: 1, title: "Test Movie", posterPath: "")
        let movieResponse = MovieResponse(listCategory: "", results: [movie])
        return movieResponse
    }

    override func parsePersonResponse(data: Data) -> PersonResponse {
        let person = Person(id: 1, name: "Test Person", profilePath:"")
        let personResponse = PersonResponse(listCategory: "", results: [person])
        return personResponse
    }

    override func parseTVResponse(data: Data) -> TVResponse {
        let tvShow = TV(id: 1, name: "Test TV", posterPath: "")
        let tvResponse = TVResponse(listCategory: "", results: [tvShow])
        return tvResponse
    }
}
