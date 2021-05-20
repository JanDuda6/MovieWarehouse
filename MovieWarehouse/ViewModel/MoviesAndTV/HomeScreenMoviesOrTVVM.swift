//
//  HomeViewModel.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation
import UIKit

class HomeScreenMoviesOrTVVM {
    private let apiService: APIService
    private let imageService: ImageService
    private var movieResponses = [MovieResponse]()
    private var personResponses = [PersonResponse]()

    private let movieEndpoints = [Endpoints.trendingMovies,Endpoints.mostPopularMoviesURL, Endpoints.topRatedMoviesURL, Endpoints.upcomingMoviesURL,Endpoints.nowPlaying, Endpoints.popularPersonsURL]

    private let tvEndpoints = [Endpoints.mostPopularTV, Endpoints.topRatedTV, Endpoints.trendingTV, Endpoints.tvOnTheAir]

    init(apiService: APIService = APIService(), imageService: ImageService = ImageService()) {
        self.apiService = apiService
        self.imageService = imageService
    }

    func fetchForHomeScreen(moviesOrTV: Bool, completion: @escaping () -> Void) {
        var endpointCounter = 0
        var endpoints = [String]()
        endpoints = moviesOrTV == true ? movieEndpoints : tvEndpoints
        apiService.performHTTPRequest(request: endpoints) { [self] (data, responseURL, responseCategory)  in
            if responseURL.contains("/movie") || responseURL.contains("/tv/") {
                var movieResponse = apiService.parseMovieResponse(data: data)
                movieResponse.listCategory = StringService.responseTitleToString(string: responseCategory)
                movieResponse.responseURL = responseURL
                for n in 0..<movieResponse.results.count {
                    movieResponse.results[n].posterImage =
                        imageService.getImageFromURL(url: imageService.profileURL(pathToImage: movieResponse.results[n].posterPath))
                }
                movieResponses.append(movieResponse)
            } else {
                var personResponse = apiService.parsePersonResponse(data: data)
                personResponse.listCategory = StringService.responseTitleToString(string: responseCategory)
                personResponse.responseURL = responseURL
                for n in 0..<personResponse.results.count {
                    personResponse.results[n].profileImage =
                        imageService.getImageFromURL(url: imageService.profileURL(pathToImage: personResponse.results[n].profilePath))
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
    
    func getMovieOrTVResponsesCount() -> Int {
        return movieResponses.count
    }

    func getMoviesOrTVShows(index: Int) -> [Movie] {
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
}
