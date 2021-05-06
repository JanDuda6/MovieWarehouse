//
//  File.swift
//  MovieWarehouse
//
//  Created by Kurs on 28/04/2021.
//

import Foundation

struct TVResponse: Codable {
    var listCategory: String = ""
    var results: [TV] = []
    var totalPages = 0
    var currentPage = 0
    var responseURL = ""

    enum CodingKeys: String, CodingKey {
        case results
        case totalPages = "total_pages"
        case currentPage = "page"
    }
}
