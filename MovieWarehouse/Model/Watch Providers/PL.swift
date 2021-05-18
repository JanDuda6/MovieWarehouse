//
//  US.swift
//  MovieWarehouse
//
//  Created by Kurs on 13/05/2021.
//

import Foundation

struct PL: Codable {
    var flatRate: [Provider]?
    var rent: [Provider]?
    var buy: [Provider]?

    enum CodingKeys: String, CodingKey {
        case flatRate = "flatrate"
        case rent
        case buy
    }
}
