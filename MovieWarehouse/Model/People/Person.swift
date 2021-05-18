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
    var characterName: String?
    var orderInCredits: Int?
    var job: String?
    var profileImage = UIImage()

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case job
        case characterName = "character"
        case profilePath = "profile_path"
        case orderInCredits = "order"
    }
}
