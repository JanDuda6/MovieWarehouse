//
//  TV.swift
//  MovieWarehouse
//
//  Created by Kurs on 28/04/2021.
//

import Foundation
import UIKit

struct TV: Codable {
    var id: Int
    var name: String
    var posterPath: String?
    var posterImage = UIImage()

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
    }

    func posterURL() -> URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "\(Endpoints.imagePathURL)\(posterPath)")
    }
}
