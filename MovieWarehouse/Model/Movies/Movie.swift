//
//  Movie.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation
import UIKit

struct Movie: Codable {
    var id: Int
    var title: String
    var posterPath: String?
    var posterImage = UIImage()
    var backdropImage = UIImage()
    var backdropPath: String?
    var genreIDs: [Int]
    var genreMap = [String]()
    var overview: String
    var voteCount: Int
    var voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
    }
}
