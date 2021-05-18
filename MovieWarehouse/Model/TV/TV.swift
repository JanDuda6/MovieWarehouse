//
//  TV.swift
//  MovieWarehouse
//
//  Created by Kurs on 28/04/2021.
//

import Foundation
import UIKit

struct TV: Codable {
    var id: Int
    var title: String
    var posterPath: String?
    var posterImage = UIImage()
    var backdropPath: String?
    var genreIDs: [Int]
    var genreMap = [String]()
    var overview: String
    var voteCount: Int
    var voteAverage: Double
    var backdropImage = UIImage()

    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case title = "name"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
    }
}
