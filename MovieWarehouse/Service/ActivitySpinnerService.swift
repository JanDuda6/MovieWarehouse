//
//  ActivitySpinnerService.swift
//  MovieWarehouse
//
//  Created by Kurs on 19/05/2021.
//

import Foundation
import UIKit

class ActivitySpinnerService {
    private let activitySpinner = UIActivityIndicatorView(style: .medium)

    func initTableViewSpinner(tableView: UITableView) {
        tableView.backgroundView = activitySpinner
        activitySpinner.color = .gray
        activitySpinner.startAnimating()
    }

    func initCollectionViewSpinner(collectionView: UICollectionView) {
        collectionView.backgroundView = activitySpinner
        activitySpinner.color = .gray
        activitySpinner.startAnimating()
    }

     func deInitActivitySpinner() {
        self.activitySpinner.stopAnimating()
    }
}
