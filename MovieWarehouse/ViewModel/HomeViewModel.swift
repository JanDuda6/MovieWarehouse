//
//  HomeViewModel.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation
import UIKit

class HomeViewModel {

    private let apiService: APIService
    private var movieResponses = [MovieResponse]()
    private var personResponses = [PersonResponse]()
    private let endpoints = [Endpoints.mostPopularMoviesURL, Endpoints.topRatedMoviesURL, Endpoints.upcomingMoviesURL,Endpoints.nowPlaying, Endpoints.popularPersonsURL]
    private var endpointCounter = 0

    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }

    func fetchMoviesForHomeScreen(completion: @escaping () -> Void) {
        apiService.performHTTPRequest(request: endpoints) { [self] (data, responseURL, responseCategory)  in
            if responseURL.contains("/movie/") {
                var movieResponse = apiService.parseMovieResponse(data: data)
                movieResponse.listCategory = responseTitleToString(string: responseCategory)
                for n in 0..<movieResponse.results.count {
                    movieResponse.results[n].posterImage =
                        ImageService.getImageFromURL(url: movieResponse.results[n].posterURL())
                }
                movieResponses.append(movieResponse)
            } else {

                var personResponse = apiService.parsePersonResponse(data: data)
                personResponse.listCategory = responseTitleToString(string: responseCategory)
                for n in 0..<personResponse.results.count {
                    personResponse.results[n].profileImage =
                        ImageService.getImageFromURL(url: personResponse.results[n].posterURL())
                }
                personResponses.append(personResponse)

            }
            endpointCounter += 1
            if endpointCounter == endpoints.count {
                completion()
            }
        }
    }

    func getResponsesCounter() -> Int {
        return movieResponses.count + personResponses.count
    }

    func getMovieResponsesCount() -> Int {
        return movieResponses.count
    }

    func getMoviesFromMovieResponse(index: Int) -> [Movie] {
        return movieResponses[index].results
    }

    func getPersonFromCastResponse(index: Int) -> [Person] {
        let indexPath = index - getResponsesCounter() + 1
        return personResponses[indexPath].results
    }

    func getListCategory(index: Int) -> String {
        if index != movieResponses.count {
            return movieResponses[index].listCategory
        } else {
            let indexPath = index - getResponsesCounter() + 1
            return personResponses[indexPath].listCategory
        }
    }

    private func responseTitleToString(string: String) -> String {
        let categoryTitle = string.replacingOccurrences(of: "_", with: " ")
        return categoryTitle.prefix(1).uppercased() + categoryTitle.lowercased().dropFirst()
    }
    // while toprated.count < 100 -> endpoint category page = 1 -> http reguest -> page +1
}
