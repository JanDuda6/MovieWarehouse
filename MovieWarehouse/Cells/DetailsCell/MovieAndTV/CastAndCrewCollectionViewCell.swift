//
//  CastAndCrewCollectionViewCell.swift
//  MovieWarehouse
//
//  Created by Kurs on 11/05/2021.
//

import UIKit

class CastAndCrewCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var personImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var characterLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.personImage.layer.cornerRadius = personImage.frame.height / 2
    }

    func setCell(image: UIImage, name: String, characterName: String) {
        self.personImage.image = image
        self.nameLabel.text = name
        self.characterLabel.text = characterName
    }
}
