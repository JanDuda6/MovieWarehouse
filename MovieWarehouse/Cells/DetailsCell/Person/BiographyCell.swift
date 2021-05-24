//
//  BiographyCell.swift
//  MovieWarehouse
//
//  Created by Kurs on 19/05/2021.
//

import UIKit

class BiographyCell: UITableViewCell {

    @IBOutlet private weak var biographyText: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setBiographyText(person: Person) {
        self.biographyText.text = person.biography
    }
}
