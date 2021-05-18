//
//  HomeScreenTVVMTest.swift
//  MovieWarehouseTests
//
//  Created by Kurs on 28/04/2021.
//

import XCTest
@testable import MovieWarehouse

class HomeScreenTVVMTests: XCTestCase {

    func testSuccessFetchForHomeScreen() {
        let apiService = MockApiService()
        let imageService = MockImageService()
        let viewModel = HomeScreenTVVM(apiService: apiService, imageService: imageService)
        var tvShows = [TV]()
        var listCategory = ""
        viewModel.fetchForHomeScreen { () in
        }
        tvShows = viewModel.getMoviesOrTVShows(index: 0).0!
        listCategory = viewModel.getListCategory(index: 0)
        XCTAssertEqual(tvShows[0].title, "Test TV")
        XCTAssertEqual(listCategory, "Top rated")
    }
}
