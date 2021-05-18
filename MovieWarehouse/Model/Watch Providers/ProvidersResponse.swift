//
//  ProvidersResponse.swift
//  MovieWarehouse
//
//  Created by Kurs on 12/05/2021.
//
//
import Foundation

struct ProvidersResponse: Codable {
    var id: Int
    var results: Results?

    enum CodingKeys: String, CodingKey {
        case id
        case results
    }
}

