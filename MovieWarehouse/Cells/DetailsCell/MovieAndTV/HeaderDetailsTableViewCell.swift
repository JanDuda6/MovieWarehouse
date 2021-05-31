//
//  HeaderDetailsTableViewCell.swift
//  MovieWarehouse
//
//  Created by Kurs on 07/05/2021.
//

import UIKit

class HeaderDetailsTableViewCell: UITableViewCell {

    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet private weak var backGroundImage: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var genre: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var watchListButton: UIButton!

    private let sessionViewModel = SessionListsVM()
    var performSession: PerformSessionDeleagte?
    var movieToShow: Movie?
    var favoriteButtonTappedCounter = 1
    var watchListButtonTappedCounter = 1

    override func awakeFromNib() {
        super.awakeFromNib()
        self.posterImage.layer.cornerRadius = 15
        self.backGroundImage.layer.cornerRadius = 15
        self.sessionViewModel.createRequestToken()
    }

    func setCell(movie: Movie) {
        self.posterImage.image = movie.posterImage
        self.backGroundImage.image = movie.backdropImage
        self.title.text = movie.title != nil ? movie.title : movie.name
        self.genre.text = movie.genreMap.joined(separator: ", ")
        self.rateLabel.text = "\(movie.voteAverage)/10 (\(movie.voteCount))"
        self.movieToShow = movie
        setFavoriteButton(movie: movieToShow!)
        setWatchListButton(movie: movieToShow!)
    }

    func setFavoriteButton(movie: Movie) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 0, weight: .regular, scale: .large)
        var image = UIImage()
        if sessionViewModel.checkIfMovieIsInFavorites(checkWatchList: false, movie: movieToShow!) == false {
            image = UIImage(systemName: "heart", withConfiguration: imageConfig)!
        } else {
            image = UIImage(systemName: "heart.slash.fill", withConfiguration: imageConfig)!
            favoriteButtonTappedCounter = 2
        }
        DispatchQueue.main.async { [self] in
            favoriteButton.setImage(image, for: .normal)
        }
    }

    func setWatchListButton(movie: Movie) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 0, weight: .regular, scale: .large)
        var image = UIImage()
        if sessionViewModel.checkIfMovieIsInFavorites(checkWatchList: true, movie: movieToShow!) == false {
            image = UIImage(systemName: "bookmark", withConfiguration: imageConfig)!
        } else {
            image = UIImage(systemName: "bookmark.slash.fill", withConfiguration: imageConfig)!
            watchListButtonTappedCounter = 2
        }
        DispatchQueue.main.async { [self] in
            watchListButton.setImage(image, for: .normal)
        }
    }

    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        let addToFavorite = favoriteButtonTappedCounter % 2 != 0 ? true : false
        if sessionViewModel.checkIfSessionIDExists() == false {
            sessionViewModel.createRequestToken()
            performSession?.shouldStartSession(requestToken: sessionViewModel.getRequestToken())
        } else {
            sessionViewModel.addToList(addToWatchList: false, addORDeleteFromList: addToFavorite, movie: movieToShow!) { [self] in
                setFavoriteButton(movie: movieToShow!)
            }
        }
        favoriteButtonTappedCounter += 1
    }

    @IBAction func watchListButtonPressed(_ sender: UIButton) {
        let addToWatchList = watchListButtonTappedCounter % 2 != 0 ? true : false
        if sessionViewModel.checkIfSessionIDExists() == false {
            sessionViewModel.createRequestToken()
            performSession?.shouldStartSession(requestToken: sessionViewModel.getRequestToken())
        } else {
            sessionViewModel.addToList(addToWatchList: true, addORDeleteFromList: addToWatchList, movie: movieToShow!) { [self] in
                setWatchListButton(movie: movieToShow!)
            }
        }
        watchListButtonTappedCounter += 1
    }
}
