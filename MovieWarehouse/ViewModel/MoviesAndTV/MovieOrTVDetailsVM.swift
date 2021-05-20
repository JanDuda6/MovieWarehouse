//
//  MovieDetailsVM.swift
//  MovieWarehouse
//
//  Created by Kurs on 07/05/2021.
//

import Foundation
import UIKit

class MovieOrTVDetailsVM {
    private var movie: Movie?
    private var apiService: APIService?
    private var genreList = [String]()
    private var castAndCrew = [Person]()
    private var movies = [Movie]()
    private let imageService: ImageService
    private var watchProviders = Set<Provider>()

    init(apiService: APIService = APIService(), imageService: ImageService = ImageService()) {
        self.apiService = apiService
        self.imageService = imageService
    }

    func setMovieOrTV(movie: Movie) {
        self.movie = movie
    }

    func fetchGenre(moviesOrTV: Bool, completion: @escaping () -> Void) {
        guard let movie = movie else { return }
        var endpoint = [String]()
        endpoint = moviesOrTV ==  true ? [Endpoints.genreMovieList] : [Endpoints.genreTVList]
        apiService?.performHTTPRequest(request: endpoint, completion: { [self] (data, _, _) in
            self.movie!.backdropImage = imageService.getImageFromURL(url: imageService.profileURL(pathToImage: movie.backdropPath))
            let dataParsed = apiService?.parseGenreResponse(data: data)
            let genreList = dataParsed!.genres
            for movieGenre in movie.genreIDs {
                for genre in  genreList {
                    if movieGenre == genre.id {
                        self.genreList.append(genre.name)
                    }
                }
            }
            self.movie!.genreMap = getGenres()
            completion()
        })
    }

    func fetchCredits(moviesOrTV: Bool, completion: @escaping () -> Void) {
        guard var movie = movie else { return }
        var endpoint = [String]()
        if moviesOrTV ==  true {
            endpoint = [Endpoints.movieCredits.replacingOccurrences(of: "{movie_id}", with: String(movie.id))]
        } else {
            endpoint = [Endpoints.TVCredits.replacingOccurrences(of: "{tv_id}", with: String(movie.id))]
        }
        apiService?.performHTTPRequest(request: endpoint) { [self] (data, _, _) in
            guard let creditsResponse = apiService?.parseCastResponse(data: data) else { return }
            
            for n in 0..<creditsResponse.cast.count {
                if creditsResponse.cast[n].orderInCredits! < 10 {
                    castAndCrew.append(creditsResponse.cast[n])
                }
            }
            for n in 0..<creditsResponse.crew.count {
                if Constants.crewJobs.contains(creditsResponse.crew[n].job!) {
                    castAndCrew.append(creditsResponse.crew[n])
                }
            }
            for n in 0..<castAndCrew.count {
                castAndCrew[n].profileImage =
                    imageService.getImageFromURL(url: imageService.profileURL(pathToImage: castAndCrew[n].profilePath))
            }
            movie.genreMap = getGenres()
            completion()
        }
    }

    func fetchProviders(moviesOrTV: Bool, completion: @escaping () -> Void) {
        guard let movie = movie else { return }
        var endpoint = [String]()
        if moviesOrTV ==  true {
            endpoint = [Endpoints.watchProvidersMovies.replacingOccurrences(of: "{movie_id}", with: String(movie.id))]
        } else {
            endpoint = [Endpoints.watchProvidersTVs.replacingOccurrences(of: "{tv_id}", with: String(movie.id))]
        }
        apiService?.performHTTPRequest(request: endpoint) { [self] (data, _, _) in
            guard let watchProvidersResponse = apiService?.parseWatchProvider(data: data) else { return }
            guard let responseResult = watchProvidersResponse.results else { return }
            guard let providers = responseResult.PL else {return}
            let emptyProvider = [Provider]()
            let providerArray = (providers.buy ?? emptyProvider)  + (providers.flatRate ?? emptyProvider) + (providers.rent ?? emptyProvider)

            for provider in providerArray {
                var providerWithImage = provider
                providerWithImage.providerLogoImage = imageService.getImageFromURL(url: imageService.profileURL(pathToImage: providerWithImage.providerLogoPath))
                watchProviders.insert(providerWithImage)
            }
            completion()
        }
    }

    func fetchRecommended(moviesOrTV: Bool, completion: @escaping () -> Void) {
        guard let movie = movie else { return }
            var endpoint = [String]()
            if moviesOrTV ==  true {
                endpoint = [Endpoints.getRecommendationMovies.replacingOccurrences(of: "{movie_id}", with: String(movie.id))]
            } else {
                endpoint = [Endpoints.getRecommendationTVShows.replacingOccurrences(of: "{tv_id}", with: String(movie.id))]
            }
        apiService?.performHTTPRequest(request: endpoint) { [self] (data, _, _) in
            guard var recommendedResponse = apiService?.parseMovieResponse(data: data) else { return }
            for n in 0..<recommendedResponse.results.count {
                recommendedResponse.results[n].posterImage = imageService.getImageFromURL(url: imageService.profileURL(pathToImage: recommendedResponse.results[n].posterPath))
            }
            movies.append(contentsOf: recommendedResponse.results)
            completion()
        }
    }

    func getCastAndCrew() -> [Person] {
        return castAndCrew
    }

    func getWatchProviders() -> Set<Provider> {
        return watchProviders
    }

    private func getGenres() -> [String] {
        let slicedGenreList = (genreList.count > 2) ? Array(genreList.prefix(2)) : genreList
        return slicedGenreList
    }

    func getRecommendation() -> ([Movie]) {
        return movies
    }

    func getObject() -> Movie {
        return movie!
    }
}
