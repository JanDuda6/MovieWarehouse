//
//  MovieRespond.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation

struct MovieResponse: Codable {
    var listCategory: String = ""
    var results: [Movie] = []

    enum CodingKeys: String, CodingKey {
        case results
    }
}
