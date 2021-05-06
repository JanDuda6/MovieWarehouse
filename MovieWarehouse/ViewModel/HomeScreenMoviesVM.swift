//
//  HomeViewModel.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation
import UIKit

class HomeScreenMoviesVM {

    private let apiService: APIService
    private let imageService: ImageService

    private var movieResponses = [MovieResponse]()
    private var personResponses = [PersonResponse]()

    private let endpoints = [Endpoints.trendingMovies,Endpoints.mostPopularMoviesURL, Endpoints.topRatedMoviesURL, Endpoints.upcomingMoviesURL,Endpoints.nowPlaying, Endpoints.popularPersonsURL]

    init(apiService: APIService = APIService(), imageService: ImageService = ImageService()) {
        self.apiService = apiService
        self.imageService = imageService
    }

    func fetchForHomeScreen(completion: @escaping () -> Void) {
        var endpointCounter = 0
        apiService.performHTTPRequest(request: endpoints) { [self] (data, responseURL, responseCategory)  in
            if responseURL.contains("/movie/") {
                var movieResponse = apiService.parseMovieResponse(data: data)
                movieResponse.listCategory = StringService.responseTitleToString(string: responseCategory)
                movieResponse.responseURL = responseURL
                for n in 0..<movieResponse.results.count {
                    movieResponse.results[n].posterImage =
                        imageService.getImageFromURL(url: movieResponse.results[n].posterURL())
                }
                movieResponses.append(movieResponse)
            } else {
                var personResponse = apiService.parsePersonResponse(data: data)
                personResponse.listCategory = StringService.responseTitleToString(string: responseCategory)
                personResponse.responseURL = responseURL
                for n in 0..<personResponse.results.count {
                    personResponse.results[n].profileImage =
                        imageService.getImageFromURL(url: personResponse.results[n].posterURL())
                }
                personResponses.append(personResponse)
            }
            endpointCounter += 1
            if endpointCounter == endpoints.count {
                completion()
            }
        }
    }

    func getMovieOrTVResponseURL(index: Int) -> String {
        return movieResponses[index].responseURL
    }

    func getPersonResponseURL(index: Int) -> String {
        let indexPath = index - getResponsesCounter() + 1
        return personResponses[indexPath].responseURL
    }

    func getResponsesCounter() -> Int {
        return movieResponses.count + personResponses.count
    }
    
    func getMovieResponsesCount() -> Int {
        return movieResponses.count
    }

    func getMoviesOrTVShows(index: Int) -> ([TV]?, [Movie]?) {
        return (nil ,movieResponses[index].results)
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
}
