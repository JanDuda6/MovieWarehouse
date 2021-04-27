//
//  Movie.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation
import UIKit

struct Movie: Codable {
    var id: Int
    var title: String
    var posterPath: String?
    var posterImage = UIImage()

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
    }

    func posterURL() -> URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "\(Endpoints.imagePathURL)\(posterPath)")
    }

}
