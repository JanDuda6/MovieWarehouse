//
//  PersonRespond.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation

struct PersonResponse: Codable {
    var listCategory: String = ""
    var results: [Person] = []

    enum CodingKeys: String, CodingKey {
        case results
    }
}
