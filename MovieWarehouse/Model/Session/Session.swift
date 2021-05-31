//
//  Session.swift
//  MovieWarehouse
//
//  Created by Kurs on 27/05/2021.
//

import Foundation

struct Session: Codable {
    var sessionID: String

    enum CodingKeys: String, CodingKey {
        case sessionID = "session_id"
    }
}
