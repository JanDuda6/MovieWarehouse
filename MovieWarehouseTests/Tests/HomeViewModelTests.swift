//
//  MovieWarehouseTests.swift
//  MovieWarehouseTests
//
//  Created by Kurs on 19/04/2021.
//

import XCTest
@testable import MovieWarehouse

class HomeViewModelTests: XCTestCase {

    func testSuccessFetchForHomeScreen() {
        let apiService = MockApiService()
        let imageService = MockImageService()
        let viewModel = HomeScreenMoviesVM(apiService: apiService, imageService: imageService)
        var movies = [Movie]()
        var persons = [Person]()
        var listCategory = ""
        viewModel.fetchForHomeScreen { () in
        }
        movies = viewModel.getMoviesOrTVShows(index: 0).1!
        persons = viewModel.getPersonFromCastResponse(index: 1)
        listCategory = viewModel.getListCategory(index: 0)
        XCTAssertEqual(movies[0].title, "Test Movie")
        XCTAssertEqual(persons[0].name, "Test Person")
        XCTAssertEqual(listCategory, "Top rated")
    }
}
