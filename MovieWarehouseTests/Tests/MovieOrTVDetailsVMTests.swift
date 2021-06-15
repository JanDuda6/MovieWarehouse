//
//  MovieOrTVDetailsVMTests.swift
//  MovieWarehouseTests
//
//  Created by Kurs on 15/06/2021.
//

import XCTest
@testable import MovieWarehouse

class MovieOrTVDetailsVMTests: XCTestCase {
    let imageService = MockImageService()

    func testSuccessFetchMovieDetails() {
        let mockMovie = Movie(id: 1, genreIDs: [1,2])
        let apiService = MockApiServiceMoviesAndPerson()
        let viewModel = MovieOrTVDetailsVM(apiService: apiService, imageService: imageService)
        viewModel.setMovieOrTV(movie: mockMovie)
        var genreList = ""
        var castAndCrew = [Person]()
        var watchProviders = Set<Provider>()
        viewModel.fetchGenre(moviesOrTV: true) {}
        viewModel.fetchCredits(moviesOrTV: true) {}
        viewModel.fetchProviders(moviesOrTV: true) {}
        genreList = viewModel.getGenres()
        castAndCrew = viewModel.getCastAndCrew()
        watchProviders = viewModel.getWatchProviders()
        let providers = Array(watchProviders)
        XCTAssertEqual(genreList, "Drama, Comedy")
        XCTAssertEqual(castAndCrew[0].name, "Test Cast Person")
        XCTAssertEqual(providers[0].id, 1)
    }
}
