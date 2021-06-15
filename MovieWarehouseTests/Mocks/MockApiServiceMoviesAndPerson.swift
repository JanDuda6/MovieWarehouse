//
//  MockApiService.swift
//  MovieWarehouseTests
//
//  Created by Kurs on 22/04/2021.
//

import Foundation
import XCTest
@testable import MovieWarehouse

class MockApiServiceMoviesAndPerson: APIService {

    override func performGetHTTPRequest(request: [String], completion: @escaping (Data, String, String) -> Void) {
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

    override func parseGenreResponse(data: Data) -> GenreResponse {
        let drama = Genre(id: 1, name: "Drama")
        let comedy = Genre(id: 2, name: "Comedy")
        let genreResponse = GenreResponse(genres: [drama, comedy])
        return genreResponse
    }

    override func parseWatchProvider(data: Data) -> ProvidersResponse {
        let provider = Provider(id: 1, providerLogoPath: "", providerLogoImage: UIImage())
        let pl = PL(flatRate: [provider], rent: nil, buy: nil)
        let results = Results(PL: pl)
        let watchProviderResponse = ProvidersResponse(id: 1, results: results)
        return watchProviderResponse
    }

    override func parseCastResponse(data: Data) -> CreditsResponse {
        let cast = Person(id: 1, name: "Test Cast Person", profilePath: "")
        let crew = Person(id: 1, name: "Test Crew Person", profilePath: "")
        let castResponse = CreditsResponse(id: 1, cast: [cast], crew: [crew])
        return castResponse
    }

    override func parsePersonCastData(data: Data) -> PersonCredits {
        let castMovie = [Movie(id: 1, title: "Ad Astra"), Movie(id: 2, title: "Fury")]
        let crewMovie = Movie(id: 3, title: "Minari")
        let personCredits = PersonCredits(cast: castMovie, crew: [crewMovie])
        return personCredits
    }
}
