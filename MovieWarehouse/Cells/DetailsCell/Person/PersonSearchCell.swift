//
//  PersonSearchCell.swift
//  MovieWarehouse
//
//  Created by Kurs on 24/05/2021.
//

import UIKit

class PersonSearchCell: UITableViewCell {

    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.personImage.layer.cornerRadius = personImage.frame.height / 2
    }

    func setCell(person: Person) {
        self.personImage.image = person.profileImage
        self.nameLabel.text = person.name
        self.departmentLabel.text = person.knownForDepartment
    }
}
