//
//  MockApiServiceForTV.swift
//  MovieWarehouseTests
//
//  Created by Kurs on 15/06/2021.
//

import Foundation
import XCTest
@testable import MovieWarehouse

class MockApiServiceForTV: APIService {

    override func performGetHTTPRequest(request: [String], completion: @escaping (Data, String, String) -> Void) {
        let data = Data()
        var responseURL = ""
        let responseCategory = "Popular"
        responseURL = "/tv/"
        completion(data, responseURL, responseCategory)
    }

    override func parseMovieResponse(data: Data) -> MovieResponse {
        let movie = Movie(id: 1, name: "Test TV", posterPath: "")
        let movieResponse = MovieResponse(listCategory: "", results: [movie])
        return movieResponse
    }
}
