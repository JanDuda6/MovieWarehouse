//
//  Movie.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation
import UIKit

struct Movie: Codable, Hashable {
    var id: Int
    var title: String?
    var name: String?
    var posterPath: String?
    var posterImage = UIImage()
    var backdropImage = UIImage()
    var backdropPath: String?
    var genreIDs: [Int]
    var genreMap = [String]()
    var overview: String
    var voteAverage: Double
    var mediaType: String?
    var releaseDate: String?
    var firstAirDate: String?
    var premiereDate = ""
    var userRating = 0

    func hash(into hasher: inout Hasher) {
         hasher.combine(id)
     }

     static func ==(lhs: Movie, rhs: Movie) -> Bool {
         return lhs.id == rhs.id
     }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case voteAverage = "vote_average"
        case mediaType = "media_type"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
    }
}
