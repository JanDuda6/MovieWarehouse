//
//  RateObjectVM.swift
//  MovieWarehouse
//
//  Created by Kurs on 09/06/2021.
//

import Foundation


class RateObjectVM {
    private var apiService: APIService
    private var requestToken = ""
    private var sessionID = ""
    private var movie: Movie?
    private var rating: String?

    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }

    func getMovieRating(completion: @escaping (Int?) -> Void) {
        var dictName = ""
        dictName = movieOrTV() == false ? "ratedMovies" : "ratedTV"
        if let ratedMovies = UserDefaults.standard.dictionary(forKey: dictName) {
            for movie in ratedMovies {
                if Int(movie.key) == self.movie!.id {
                    completion((movie.value as? Int)!)
                } else {
                    completion(nil)
                }
            }
        }
    }

    func setRating(rating: Int) {
        if rating < 1 { return }
        var dictName = ""
        dictName = movieOrTV() == false ? "ratedMovies" : "ratedTV"
        if var ratedMovies = UserDefaults.standard.dictionary(forKey: dictName) {
            ratedMovies["\(self.movie!.id)"] = rating
            UserDefaults.standard.set(ratedMovies, forKey: dictName)
        } else {
            let ratingDict = ["\(self.movie!.id)" : rating]
            UserDefaults.standard.set(ratingDict, forKey: dictName)
        }
    }

    func sendRatingToApi(rating: Int) {
        let rate = Rate(value: rating)
        let data = apiService.parseRatingToData(rating: rate)
        let endpoint = createEndpoint(endpoint: PostEndpoints.postRatedMovies)
        apiService.performPostHTTPRequest(data: data, stringURL: endpoint) { _ in
        }
    }

    func deleteRating() {
        var dictName = ""
        let endpoint = createEndpoint(endpoint: PostEndpoints.postRatedMovies)
        apiService.performDeleteHTTPRequest(url: endpoint) { [self] data in
            let alert = apiService.parseAlert(data: data)
            print(alert)
            dictName = movieOrTV() == false ? "ratedMovies" : "ratedTV"
            if var ratedMovies = UserDefaults.standard.dictionary(forKey: dictName) {
                for movie in ratedMovies {
                    if Int(movie.key) == self.movie!.id {
                        ratedMovies.removeValue(forKey: movie.key)
                        UserDefaults.standard.set(ratedMovies, forKey: dictName)
                    }
                }
            }
        }
    }

    private func createEndpoint(endpoint: String) -> String {
        var endpoint = endpoint
        var changeCategory = ""
        if movie?.name != nil {
            changeCategory = endpoint.replacingOccurrences(of: "{movie}", with: "tv")
        } else {
            changeCategory = endpoint.replacingOccurrences(of: "{movie}", with: "movie")
        }
        endpoint = changeCategory
        let endpointWithID = endpoint.replacingOccurrences(of: "{movie_id}", with: String(movie!.id))
        let sessionID = UserDefaults.standard.string(forKey: "sessionID")
        let result = endpointWithID + "&session_id=\(sessionID!)"
        return result
    }

    func setMovie(movie: Movie) {
        self.movie = movie
    }

    private func movieOrTV() -> Bool {
        if movie?.name == nil {
            return false
        } else {
            return true
        }
    }
}
