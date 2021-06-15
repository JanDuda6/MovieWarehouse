//
//  PersonDetailsVMTests.swift
//  MovieWarehouseTests
//
//  Created by Kurs on 15/06/2021.
//

import XCTest
@testable import MovieWarehouse

class PersonDetailsVMTests: XCTestCase {
    let imageService = MockImageService()

    func testSuccessFetchPersonDetails() {
        let mockPerson = Person(id: 1, name: "Brad Pitt")
        let apiService = MockApiServiceMoviesAndPerson()
        let viewModel = PersonDetailsVM(apiService: apiService, imageService: imageService)
        var personMovies = [Movie]()
        viewModel.setPerson(person: mockPerson)
        viewModel.fetchPersonCredits {}
        personMovies = viewModel.getPersonCredits()
        XCTAssertEqual(personMovies[0].title, "Ad Astra")
        XCTAssertEqual(personMovies[1].title, "Fury")
        XCTAssertEqual(personMovies[2].title, "Minari")
    }
}
