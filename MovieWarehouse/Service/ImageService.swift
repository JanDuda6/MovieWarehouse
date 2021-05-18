//
//  ImageService.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation
import UIKit

class ImageService {
    
     func profileURL(pathToImage: String?) -> URL? {
         guard let imagePath = pathToImage else { return nil }
         return URL(string: "\(Endpoints.imagePathURL)\(imagePath)")
     }

    func getImageFromURL(url: URL?) -> UIImage {
        if url != nil {
            let dataImage = try! Data(contentsOf: url!)
            let image = UIImage(data: dataImage)
            return image!
        } else {
            return UIImage()
        }
    }
}
