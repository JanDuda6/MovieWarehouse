//
//  PlayerVM.swift
//  MovieWarehouse
//
//  Created by Kurs on 15/06/2021.
//

import Foundation

class PlayerVM {
    private var apiService: APIService
    private var movie: Movie?
    private var videoKey = ""

    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }

    func setMovieID(movie: Movie) {
        self.movie = movie
    }

    func fetchVideoKey(completion: @escaping () -> Void) {
        let endpoint = getEndpoint()
        apiService.performGetHTTPRequest(request: [endpoint]) { [self] data, _, _ in
            var videos = [Video]()
            let videoResults = apiService.parseVideoResults(data: data)
            for video in videoResults.results {
                if video.type == "Trailer" {
                    videos.append(video)
                }
            }
            if videos.count > 0 {
                self.videoKey = videos.first!.key
            }
            completion()
        }
    }

    func getVideoKey() -> String {
        return videoKey
    }

    private func getEndpoint() -> String {
        var endpoint = ""
        if movie!.name == nil {
            endpoint = GetEndpoints.getMovieTrailers.replacingOccurrences(of: "{movie_id}", with: String(self.movie!.id))
        } else {
            endpoint = GetEndpoints.getTVTrailers.replacingOccurrences(of: "{tv_id}", with: String(self.movie!.id))
        }
        return endpoint
    }
}
