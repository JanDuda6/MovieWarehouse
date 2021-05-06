//
//  HomeScreenCell.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation
import UIKit

protocol PerformSegueDelegate {
    func didPerformSegue(responseURL: String)
}

class HomeScreenCell: UITableViewCell, UICollectionViewDelegateFlowLayout {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var seeAllButton: UIButton!
    @IBOutlet private weak var stackViewLabelAndButton: UIStackView!
    @IBOutlet private weak var collectionStackView: UIStackView!

    var performSegueDelegate: PerformSegueDelegate?

    private var movies = [Movie]()
    private var persons = [Person]()
    private var tvShows = [TV]()
    private var showPersonsCollection = false
    private var showTVCollection = false
    private var responseURL = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        addTapGestureToCollectionView()
        setCollectionViewConstraints()
        setLabelAndButtonStackView()
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

    func setTVShowArray(tv: [TV], changeCollection: Bool) {
        self.tvShows = tv
        self.showTVCollection = true
    }

    func setResponseURL(url: String) {
        self.responseURL = url
    }

    @IBAction private func seeMoreButtonTapped(_ sender: UIButton) {
        performSegueDelegate?.didPerformSegue(responseURL: responseURL)
    }
}

//MARK: - Collection View
extension HomeScreenCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var collectionRows = 0
        switch showTVCollection {
        case true:
            collectionRows = tvShows.count
        default:
            collectionRows = self.showPersonsCollection == false ? movies.count : persons.count
        }
        return collectionRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
        if showPersonsCollection == true {
            cell.setCollectionViewCell(image: persons[indexPath.row].profileImage, title: persons[indexPath.row].name)
        }
        if showPersonsCollection == false && showTVCollection == false {
            cell.setCollectionViewCell(image: movies[indexPath.row].posterImage, title: movies[indexPath.row].title)
        }
        if showTVCollection == true {
            cell.setCollectionViewCell(image: tvShows[indexPath.row].posterImage, title: tvShows[indexPath.row].name)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let screenWidth = UIScreen.main.bounds.size.width
        var width: CGFloat = 0

        switch screenWidth {
        case 375...428:
             width = (self.collectionView.bounds.width - 30)/2
        case 429...834:
            width = (self.collectionView.bounds.width - 50)/4
        default:
             width = (self.collectionView.bounds.width - 60)/5
        }
        let height  = width * 1.7
        return CGSize(width: width, height: height)
    }

    override func prepareForReuse() {
        collectionView.contentOffset = .zero
        collectionView.reloadData()
    }
}

//MARK: - Tap Gesture
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

//MARK: - Constraints
extension HomeScreenCell {
    private func setCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            self.collectionStackView.topAnchor.constraint(equalTo: self.stackViewLabelAndButton.bottomAnchor),
            self.collectionStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.collectionStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.collectionStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10)
        ])
    }

    private func setLabelAndButtonStackView() {
        NSLayoutConstraint.activate([
            self.stackViewLabelAndButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.stackViewLabelAndButton.bottomAnchor.constraint(equalTo: self.collectionStackView.topAnchor),
            self.stackViewLabelAndButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.stackViewLabelAndButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30)
        ])
    }
}
