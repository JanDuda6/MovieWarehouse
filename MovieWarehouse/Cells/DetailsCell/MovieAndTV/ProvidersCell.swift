//
//  ProvidersCell.swift
//  MovieWarehouse
//
//  Created by Kurs on 13/05/2021.
//

import UIKit

class ProvidersCell: UICollectionViewCell {

    @IBOutlet private weak var providerImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCell(providerImage: UIImage) {
        self.providerImage.image = providerImage
    }

    func setImageConstraintsForPosters() {
        let widthConstraint = NSLayoutConstraint(item: self.providerImage!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 125)
        let heightConstraint = NSLayoutConstraint(item: self.providerImage!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 190)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
        self.providerImage.layer.cornerRadius = 10
    }

    func setImageConstraintsForProviders() {
        let widthConstraint = NSLayoutConstraint(item: self.providerImage!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60)
        let heightConstraint = NSLayoutConstraint(item: self.providerImage!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60)
        NSLayoutConstraint.activate([widthConstraint, heightConstraint])
        self.providerImage.layer.cornerRadius = providerImage.frame.height / 2
    }
}
