//
//  MovieWarehouseTests.swift
//  MovieWarehouseTests
//
//  Created by Kurs on 19/04/2021.
//

import XCTest
@testable import MovieWarehouse

class HomeViewModelTests: XCTestCase {

    func testSuccessFetchMoviesForHomeScreen() {
        let apiService = MockApiService()
        let viewModel = HomeViewModel(apiService: apiService)
        viewModel.fetchMoviesForHomeScreen { () in
            let movies = viewModel.getMoviesFromMovieResponse(index: 0)
            let persons = viewModel.getPersonFromCastResponse(index: 1)
            let listCategory = viewModel.getListCategory(index: 4)
            XCTAssertEqual(movies[0].title, "Test Movie")
            XCTAssertEqual(persons[0].name, "Test Person")
            XCTAssertEqual(listCategory, "Popular")
        }
    }
}
