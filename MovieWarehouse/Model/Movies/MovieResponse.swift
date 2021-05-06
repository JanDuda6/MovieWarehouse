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
    var totalPages = 0
    var currentPage = 0
    var responseURL = ""

    enum CodingKeys: String, CodingKey {
        case results
        case totalPages = "total_pages"
        case currentPage = "page"
    }
}
