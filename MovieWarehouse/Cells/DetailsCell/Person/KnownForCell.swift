//
//  KnownForCell.swift
//  MovieWarehouse
//
//  Created by Kurs on 19/05/2021.
//

import UIKit

class KnownForCell: UITableViewCell {

    @IBOutlet private weak var posterCell: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.posterCell.layer.cornerRadius = 10
    }

    func setKnownForCell(movie: Movie) {
        self.posterCell.image = movie.posterImage
        if movie.name == nil {
            self.titleLabel.text = movie.title
        } else {
            self.titleLabel.text = movie.name
        }
        self.rateLabel.text = "\(movie.voteAverage)/10"
        self.genreLabel.text = "\(movie.mediaType ?? "") \(movie.premiereDate)"
    }
}
