//
//  HomeCollectionCel.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation
import UIKit

class HomeCollectionCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCollectionViewCell(image: UIImage, title: String) {
        self.imageView.layer.cornerRadius = 5
        self.imageView.image = image
        self.titleLabel.text = title
    }
}
