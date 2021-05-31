//
//  Alert.swift
//  MovieWarehouse
//
//  Created by Kurs on 28/05/2021.
//

import Foundation

struct Alert: Codable {
    var code: Int
    var message: String

    enum CodingKeys: String, CodingKey {
        case code = "status_code"
        case message = "status_message"
    }
}
