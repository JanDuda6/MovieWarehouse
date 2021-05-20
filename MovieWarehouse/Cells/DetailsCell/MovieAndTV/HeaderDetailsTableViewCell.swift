//
//  HeaderDetailsTableViewCell.swift
//  MovieWarehouse
//
//  Created by Kurs on 07/05/2021.
//

import UIKit

class HeaderDetailsTableViewCell: UITableViewCell {

    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet private weak var backGroundImage: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var genre: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.posterImage.layer.cornerRadius = 15
        self.backGroundImage.layer.cornerRadius = 15
    }

    func setCell(movie: Movie) {
        self.posterImage.image = movie.posterImage
        self.backGroundImage.image = movie.backdropImage
        self.title.text = movie.title != nil ? movie.title : movie.name
        self.genre.text = movie.genreMap.joined(separator: ", ")
        self.rateLabel.text = "\(movie.voteAverage)/10 (\(movie.voteCount))"
    }
}
