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
        let viewModel = HomeScreenTVVM(apiService: apiService)
        viewModel.fetchForHomeScreen { () in
            let tvShows = viewModel.getMoviesOrTVShows(index: 0).0
            let listCategory = viewModel.getListCategory(index: 0)
            XCTAssertEqual(tvShows![0].name, "Test TV")
            print("aaaa \(listCategory)")
            XCTAssertEqual(listCategory, "")
        }
    }
}
