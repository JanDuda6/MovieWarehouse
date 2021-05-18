//
//  TVDetailsVM.swift
//  MovieWarehouse
//
//  Created by Kurs on 18/05/2021.
//

import Foundation

class TVDetailsVM: MovieDetailsVM {
    private var tvShow: TV?
    private var apiService: APIService?
    private var genreList = [String]()
    private var castAndCrew = [Person]()
    private var tvShows = [TV]()
    private let imageService: ImageService
    private var watchProviders = Set<Provider>()

    override init(apiService: APIService = APIService(), imageService: ImageService = ImageService()) {
        self.apiService = apiService
        self.imageService = imageService
    }

    override func setObject(movie: Movie?, tv: TV?) {
        self.tvShow = tv
    }

    override func fetchGenre(completion: @escaping () -> Void) {
        guard let tvShow = tvShow else { return }
        apiService?.performHTTPRequest(request: [Endpoints.genreTVList], completion: { [self] (data, _, _) in
            self.tvShow!.backdropImage = imageService.getImageFromURL(url: imageService.profileURL(pathToImage: tvShow.backdropPath))
            let dataParsed = apiService?.parseGenreResponse(data: data)
            let genreList = dataParsed!.genres
            for tvGenre in tvShow.genreIDs {
                for genre in  genreList {
                    if tvGenre == genre.id {
                        self.genreList.append(genre.name)
                    }
                }
            }
            completion()
        })
    }

    override func fetchCredits(completion: @escaping () -> Void) {
        guard let tv = tvShow else { return }
        let creditsEndpoint = Endpoints.TVCredits.replacingOccurrences(of: "{tv_id}", with: String(tv.id))
        apiService?.performHTTPRequest(request: [creditsEndpoint]) { [self] (data, _, _) in
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
            completion()
        }
    }

    override func fetchProviders(completion: @escaping () -> Void) {
        guard let tv = tvShow else { return }
        let objectWatchProviders = Endpoints.watchProvidersTVs.replacingOccurrences(of: "{tv_id}", with: String(tv.id))
        apiService?.performHTTPRequest(request: [objectWatchProviders]) { [self] (data, _, _) in
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

    override func fetchRecommended(completion: @escaping () -> Void) {
        guard let tv = tvShow else { return }
        let recommendedMovieEndpoint = Endpoints.getRecommendationTVShows.replacingOccurrences(of: "{tv_id}", with: String(tv.id))
        apiService?.performHTTPRequest(request: [recommendedMovieEndpoint]) { [self] (data, _, _) in
            guard var recommendedResponse = apiService?.parseTVResponse(data: data) else { return }
            for n in 0..<recommendedResponse.results.count {
                recommendedResponse.results[n].posterImage = imageService.getImageFromURL(url: imageService.profileURL(pathToImage: recommendedResponse.results[n].posterPath))
            }
            tvShows.append(contentsOf: recommendedResponse.results)
            completion()
        }
    }

    override func getCastAndCrew() -> [Person] {
        return castAndCrew
    }

    override func getWatchProviders() -> Set<Provider> {
        return watchProviders
    }

    override func getMovieGenres() -> [String] {
        let slicedGenreList = (genreList.count > 2) ? Array(genreList.prefix(2)) : genreList
        return slicedGenreList
    }

    override func getRecommendation() -> ([Movie]?, [TV]?) {
        return (nil, tvShows)
    }

    override func getObject() -> (Movie?, TV?) {
        return (nil, tvShow)
    }
}
