//
//  SearchObjectsVM.swift
//  MovieWarehouse
//
//  Created by Kurs on 24/05/2021.
//

import Foundation
import UIKit

class SearchObjectsVM {

    private var apiService: APIService
    private var imageService: ImageService
    private var movies = [Movie]()
    private var persons = [Person]()
    private var currentPage = 1
    private var totalPages = Int.max

    init(apiService: APIService = APIService(), imageService: ImageService = ImageService()) {
        self.apiService = apiService
        self.imageService = imageService
    }

    func fetchDataFromSearchBar(query: String, segment: String, completion: @escaping () -> Void) {
        guard currentPage < totalPages  else { return }
        var endpoint = ""
        let urlEncoded = query.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let query = "&query=\(urlEncoded!)"
        let page = "&page=\(currentPage)"
        switch segment {
        case "TV":
            endpoint = Endpoints.searchTvShow
        case "Movie":
            endpoint = Endpoints.searchMovies
        case "Person":
            endpoint = Endpoints.searchPerson
        default:
            break
        }
        endpoint = endpoint + query + page
        apiService.performHTTPRequest(request: [endpoint]) { [self] (data, _, _) in
            if segment != "Person" {
                let movieResponse = apiService.parseMovieResponse(data: data)
                var results = movieResponse.results
                totalPages = movieResponse.totalPages
                currentPage = movieResponse.currentPage + 1
                for n in 0..<results.count {
                    results[n].posterImage =
                        imageService.getImageFromURL(url: imageService.profileURL(pathToImage: results[n].posterPath))
                }
                movies.append(contentsOf: results)

            } else {
                let personResponse = apiService.parsePersonResponse(data: data)
                var results = personResponse.results
                totalPages = personResponse.totalPages
                currentPage = personResponse.currentPage + 1
                for n in 0..<results.count {
                    results[n].profileImage =
                        imageService.getImageFromURL(url: imageService.profileURL(pathToImage: results[n].profilePath))
                }
                persons.append(contentsOf: results)
            }
            completion()
        }
    }

    func getMovieResult() -> [Movie] {
        for n in 0..<movies.count {
            if movies[n].title != nil {
                movies[n].premiereDate = movies[n].releaseDate ?? ""
            } else {
                movies[n].premiereDate = movies[n].firstAirDate ?? ""
            }
            movies[n].premiereDate = StringService.dateTrimm(date: movies[n].premiereDate)
        }
        return movies
    }

    func getPersonResults() -> [Person] {
        return persons
    }

    func setEmptyMovieAndPersonArray() {
        self.movies = [Movie]()
        self.persons = [Person]()
        self.currentPage = 1
    }
}
