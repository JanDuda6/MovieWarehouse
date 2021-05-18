//
//  Provider.swift
//  MovieWarehouse
//
//  Created by Kurs on 12/05/2021.
//

import Foundation
import UIKit

struct Provider: Codable, Hashable {
    var id: Int?
    var providerLogoPath: String?
    var providerLogoImage = UIImage()

    enum CodingKeys: String, CodingKey {
        case id = "provider_id"
        case providerLogoPath = "logo_path"
    }

    func hash(into hasher: inout Hasher) {
         hasher.combine(id)
     }

     static func ==(lhs: Provider, rhs: Provider) -> Bool {
         return lhs.id == rhs.id
     }
}

