//
//  KnownForCell.swift
//  MovieWarehouse
//
//  Created by Kurs on 19/05/2021.
//

import UIKit

class KnownForCell: UITableViewCell {

    @IBOutlet weak var posterCell: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.posterCell.layer.cornerRadius = 10
    }

    func setKnownForCell() {

    }
}
