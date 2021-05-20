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
    
    func setCollectionViewMovieCell(movie: Movie) {
        self.imageView.layer.cornerRadius = 10
        self.imageView.image = movie.posterImage
        if movie.name == nil {
            self.titleLabel.text = movie.title
        } else {
            self.titleLabel.text = movie.name
        }
    }

    func setCollectionViewPersonCell(person: Person) {
        self.imageView.layer.cornerRadius = 10
        self.imageView.image = person.profileImage
        self.titleLabel.text = person.name
    }
}
