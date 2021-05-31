//
//  RequestToken.swift
//  MovieWarehouse
//
//  Created by Kurs on 27/05/2021.
//

import Foundation

struct RequestToken: Codable {
    var requestToken: String

    enum CodingKeys: String, CodingKey {
        case requestToken = "request_token"
    }
}
