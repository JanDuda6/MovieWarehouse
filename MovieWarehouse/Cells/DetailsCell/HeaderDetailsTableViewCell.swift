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

    func setMovieCell(movie: Movie) {
        self.posterImage.image = movie.posterImage
        self.backGroundImage.image = movie.backdropImage
        self.title.text = movie.title
        self.genre.text = movie.genreMap.joined(separator: ", ")
        self.rateLabel.text = "\(movie.voteAverage)/10 (\(movie.voteCount))"
    }

    func setTVCell(tv: TV) {
        self.posterImage.image = tv.posterImage
        self.backGroundImage.image = tv.backdropImage
        self.title.text = tv.title
        self.genre.text = tv.genreMap.joined(separator: ", ")
        self.rateLabel.text = "\(tv.voteAverage)/10 (\(tv.voteCount))"
    }
}
