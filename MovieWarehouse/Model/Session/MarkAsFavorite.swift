//
//  MarkAsFavorite.swift
//  MovieWarehouse
//
//  Created by Kurs on 28/05/2021.
//

import Foundation

struct MarkAsFavorite: Codable {
    var mediaType: String
    var mediaID: Int
    var favorite: Bool?
    var watchList: Bool?

    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaID = "media_id"
        case watchList = "watchlist"
        case favorite
    }
}
