//
//  HomeView.swift
//  MovieWarehouse
//
//  Created by Kurs on 28/04/2021.
//

import Foundation

class HomeScreenTVVM: HomeScreenMoviesVM {

    private let apiService: APIService
    private let imageService: ImageService

    private var tvResponses = [TVResponse]()
    private let tvEndpoints = [Endpoints.mostPopularTV, Endpoints.topRatedTV, Endpoints.trendingTV, Endpoints.tvOnTheAir]

    override init(apiService: APIService = APIService(), imageService: ImageService = ImageService()) {
        self.apiService = apiService
        self.imageService = imageService
    }

    override func fetchForHomeScreen(completion: @escaping () -> Void) {
        var endpointCounter = 0
        apiService.performHTTPRequest(request: tvEndpoints) { [self] (data, responseURL, responseCategory)  in
            var tvResponse = apiService.parseTVResponse(data: data)
            tvResponse.listCategory = StringService.responseTitleToString(string: responseCategory)
            tvResponse.responseURL = responseURL
            for n in 0..<tvResponse.results.count {
                tvResponse.results[n].posterImage =
                    imageService.getImageFromURL(url: imageService.profileURL(pathToImage: tvResponse.results[n].posterPath))
            }
            tvResponses.append(tvResponse)
            endpointCounter += 1
            if endpointCounter == tvEndpoints.count {
                completion()
            }
        }
    }

    override func getResponsesCounter() -> Int {
        return tvResponses.count
    }

    override func getMoviesOrTVShows(index: Int) -> ([TV]?, [Movie]?) {
        return (tvResponses[index].results, nil)
    }

    override func getMovieOrTVResponseURL(index: Int) -> String {
        return tvResponses[index].responseURL
    }

    override func getListCategory(index: Int) -> String {
        return tvResponses[index].listCategory
    }
}
