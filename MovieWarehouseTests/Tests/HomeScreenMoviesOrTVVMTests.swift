//
//  MovieWarehouseTests.swift
//  MovieWarehouseTests
//
//  Created by Kurs on 19/04/2021.
//

import XCTest
@testable import MovieWarehouse

class HomeScreenMoviesOrTVVMTests: XCTestCase {
    let imageService = MockImageService()

    func testSuccessFetchForHomeScreenMovies() {
        let apiService = MockApiServiceMoviesAndPerson()
        let viewModel = HomeScreenMoviesOrTVVM(apiService: apiService, imageService: imageService)
        var movies = [Movie]()
        var persons = [Person]()
        var listCategory = ""
        // test for movie
        viewModel.fetchForHomeScreen(moviesOrTV: true) { () in
        }
        movies = viewModel.getMoviesOrTVShows(index: 0)
        persons = viewModel.getPersonFromCastResponse(index: 1)
        listCategory = viewModel.getListCategory(index: 0)
        XCTAssertEqual(movies[0].title, "Test Movie")
        XCTAssertEqual(persons[0].name, "Test Person")
        XCTAssertEqual(listCategory, "Top rated")
    }

    func testSuccessFetchForHomeScreenTV() {
        let apiService = MockApiServiceForTV()
        let viewModel = HomeScreenMoviesOrTVVM(apiService: apiService, imageService: imageService)
        var tv = [Movie]()
        var listCategory = ""
        // test for TV
        viewModel.fetchForHomeScreen(moviesOrTV: false) { () in
        }
        tv = viewModel.getMoviesOrTVShows(index: 0)
        listCategory = viewModel.getListCategory(index: 0)
        XCTAssertEqual(tv[0].name, "Test TV")
        XCTAssertEqual(listCategory, "Popular")
    }
}
