//
//  HomeScreenCell.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation
import UIKit

class HomeScreenCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var label: UILabel!

    private var movies = [Movie]()
    private var persons = [Person]()
    private var showPersonsCollection = true

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        addTapGestureToCollectionView()
        setCollectionViewConstraints()
        setLabelConstraints()
    }

    func setTableviewCellLabel(collectionViewLabel: String) {
        self.label.text = collectionViewLabel
    }

    func setMoviesArray(movies: [Movie], changeCollection: Bool) {
        self.movies = movies
        self.showPersonsCollection = changeCollection
    }

    func setPersonArray(persons: [Person], changeCollection: Bool) {
        self.persons = persons
        self.showPersonsCollection = changeCollection
    }
}

// Collection View
extension HomeScreenCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let collectionRows = movies.count != 0 ? movies.count : persons.count
        return collectionRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
        if showPersonsCollection == true {
            cell.setCollectionViewCell(image: persons[indexPath.row].profileImage, title: persons[indexPath.row].name)
        } else {
            cell.setCollectionViewCell(image: movies[indexPath.row].posterImage, title: movies[indexPath.row].title)
        }
        return cell
    }

    override func prepareForReuse() {
        collectionView.contentOffset = .zero
        collectionView.reloadData()
    }
}

// Tap Gesture Methods
extension HomeScreenCell {
   private func addTapGestureToCollectionView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        collectionView.addGestureRecognizer(tap)
        collectionView.isUserInteractionEnabled = true
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            if showPersonsCollection == true {
                print("person")
            } else {
                print("movie")
            }
        }
    }
}
// Set collectionView constraints
extension HomeScreenCell {
    private func setCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10)
        ])
    }

    private func setLabelConstraints() {
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.label.bottomAnchor.constraint(equalTo: self.collectionView.topAnchor, constant: 10),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10)
        ])
    }
}
