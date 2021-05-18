//
//  CastResponse.swift
//  MovieWarehouse
//
//  Created by Kurs on 11/05/2021.
//

import Foundation

struct CreditsResponse: Codable {
    var id: Int
    var cast: [Person]
    var crew: [Person]
}
