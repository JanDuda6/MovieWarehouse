//
//  HomeView.swift
//  MovieWarehouse
//
//  Created by Kurs on 28/04/2021.
//

import Foundation

class HomeView: HomeViewModel {

    private let apiService: APIService
     var tvResponses = [TVResponse]()
    private let tvEndpoints = [Endpoints.mostPopularTV, Endpoints.topRatedTV, Endpoints.trendingTV, Endpoints.tvOnTheAir]

    override init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }

    override func fetchMoviesForHomeScreen(completion: @escaping () -> Void) {
        var endpointCounter = 0
        apiService.performHTTPRequest(request: tvEndpoints) { [self] (data, responseURL, responseCategory)  in
                var tvResponse = apiService.parseTVResponse(data: data)
                tvResponse.listCategory = responseTitleToString(string: responseCategory)
                for n in 0..<tvResponse.results.count {
                    tvResponse.results[n].posterImage =
                        ImageService.getImageFromURL(url: tvResponse.results[n].posterURL())
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

    override func getMoviesFromMovieResponse(index: Int) -> ([TV]?, [Movie]?) {
        return (tvResponses[index].results, nil)
    }

    override func getListCategory(index: Int) -> String {
        return tvResponses[index].listCategory
    }

    private func responseTitleToString(string: String) -> String {
        var categoryTitle = string.replacingOccurrences(of: "_", with: " ")
        if categoryTitle.lowercased() == "day" {
            categoryTitle = "Trending today"
        }
        return categoryTitle.prefix(1).uppercased() + categoryTitle.lowercased().dropFirst()
    }
}
