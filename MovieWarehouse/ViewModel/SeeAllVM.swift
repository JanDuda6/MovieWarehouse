//
//  SeeAllViewModel.swift
//  MovieWarehouse
//
//  Created by Kurs on 28/04/2021.
//

import Foundation

class SeeAllVM {
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

    func fetchSeeMore(endpoint: String, completion: @escaping () -> Void) {
        guard currentPage < totalPages  else { return }
        let changePageEndpoint = endpoint + "&page=\(currentPage)"
        apiService.performHTTPRequest(request: [changePageEndpoint]) { [self] (data, _, _) in
            if endpoint.contains("/movie") || endpoint.contains("/tv/") {
                let movieResponse = apiService.parseMovieResponse(data: data)
                var results = movieResponse.results
                totalPages = movieResponse.totalPages
                currentPage = movieResponse.currentPage + 1
                for n in 0..<results.count {
                    results[n].posterImage =
                        imageService.getImageFromURL(url: imageService.profileURL(pathToImage: results[n].posterPath))
                }
                movies.append(contentsOf: results)
            }

            if endpoint.contains("/person/") {
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

    func getMovies() -> [Movie] {
        return movies
    }

    func getPersons() -> [Person] {
        return persons
    }
}
