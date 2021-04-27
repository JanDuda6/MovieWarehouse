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
}
