//
//  UsersListsVM.swift
//  MovieWarehouse
//
//  Created by Kurs on 31/05/2021.
//

import Foundation

class UsersListsVM {
    private var apiService: APIService
    private var imageService: ImageService
    private var movies = [Movie]()
    private var mediaType = "movies"
    private var selectedCategory = "favorite"
    private var currentPage = 1
    private var totalPages = Int.max

    init(apiService: APIService = APIService(), imageService: ImageService = ImageService()) {
        self.apiService = apiService
        self.imageService = imageService
    }

    func fetchList(completion: @escaping () -> Void) {
        let endpoint = createEndpoint()
        apiService.performGetHTTPRequest(request: [endpoint]) { [self] data, _, _ in
            let movieResponse = apiService.parseMovieResponse(data: data)
            var results = movieResponse.results
            totalPages = movieResponse.totalPages
            currentPage = movieResponse.currentPage + 1
            for n in 0..<results.count {
                results[n].posterImage =
                    imageService.getImageFromURL(url: imageService.profileURL(pathToImage: results[n].posterPath))
            }
            movies.append(contentsOf: results)
            completion()
        }
    }

    func getData() -> [Movie] {
        return movies
    }

    private func createEndpoint() -> String{
        let sessionID = UserDefaults.standard.string(forKey: "sessionID")
        let accountID = UserDefaults.standard.string(forKey: "accountID")
        let endpoint = GetEndpoints.getLists.replacingOccurrences(of: "{sessionID}", with: sessionID!)
        let accountEndpoint = endpoint.replacingOccurrences(of: "{account_id}", with: accountID!)
        let mediaEndpoint = accountEndpoint.replacingOccurrences(of: "{media}", with: mediaType)
        let finalEndpoint = mediaEndpoint.replacingOccurrences(of: "{category}", with: selectedCategory) + "&page=\(currentPage)"
        return finalEndpoint
    }

    func setCategory(index: Int) {
        let category = ["favorite", "watchlist", "rated"]
        self.selectedCategory = category[index]
    }

    func setMoviesOrTvLists(moviesLists: Bool) {
        self.mediaType = moviesLists == true ? "movies" : "tv"
    }

    func reuseMoviesArray() {
        self.currentPage = 1
        self.movies = [Movie]()
    }
}
