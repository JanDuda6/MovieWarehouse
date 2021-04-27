//
//  ImageService.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation
import UIKit

struct ImageService {
    static func getImageFromURL(url: URL?) -> UIImage {
        if url != nil {
            let dataImage = try! Data(contentsOf: url!)
            let image = UIImage(data: dataImage)
            return image!
        } else {
            return UIImage()
        }

    }
}
