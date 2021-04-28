//
//  MockImageService.swift
//  MovieWarehouseTests
//
//  Created by Kurs on 28/04/2021.
//

import Foundation
import UIKit
@testable import MovieWarehouse

class MockImageService: ImageService {

    override func getImageFromURL(url: URL?) -> UIImage {
        return UIImage()
    }
}
