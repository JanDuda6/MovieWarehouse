//
//  MovieOverviewCell.swift
//  MovieWarehouse
//
//  Created by Kurs on 10/05/2021.
//

import UIKit

class ObjectOverviewCell: UITableViewCell {

    @IBOutlet private weak var overviewTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCell(overview: String) {
        self.overviewTextView.text = overview
    }
}
