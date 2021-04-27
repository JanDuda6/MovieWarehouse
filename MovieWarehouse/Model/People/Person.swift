//
//  Person.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation
import UIKit

struct Person: Codable {
    var id: Int
    var name: String
    var profilePath: String?
    var profileImage = UIImage()

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
    }

    func posterURL() -> URL? {
        guard let profilePath = profilePath else { return nil }
        return URL(string: "\(Endpoints.imagePathURL)\(profilePath)")
    }
}
