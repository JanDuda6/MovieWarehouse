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
    @IBOutlet private weak var rating: UIButton!
    
    private let sessionViewModel = SessionVM()
    private let crudUserListsVM = CRUDUserListsVM()
    private let rateViewModel = RateObjectVM()
    var performSession: PerformSessionDeleagte?
    var performRating: PerformRatingDelegate?
    var performPlayVideo: PerformPlayVideoDelegate?
    var movieToShow: Movie?
    var favoriteButtonTappedCounter = 1
    var watchListButtonTappedCounter = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.posterImage.layer.cornerRadius = 15
        self.backGroundImage.layer.cornerRadius = 15
    }
    
    func setCell(movie: Movie) {
        self.posterImage.image = movie.posterImage
        self.backGroundImage.image = movie.backdropImage
        self.title.text = movie.title != nil ? movie.title : movie.name
        self.rateLabel.text = "\(movie.voteAverage!)/10"
        self.movieToShow = movie
        setFavoriteButton(movie: movieToShow!)
        setWatchListButton(movie: movieToShow!)
        rateViewModel.setMovie(movie: movieToShow!)
        setRatingButton()
        if movieToShow?.userRating != 0 {
            self.rating.setTitle("\(movieToShow!.userRating)/10", for: .normal)
        } else {
            self.rating.setTitle("Rate this", for: .normal)
        }
    }

    func setGenres(genre: String) {
        self.genre.text = genre
    }

    func setVideoKey(videoKey: String) {
        self.movieToShow!.videoKey = videoKey
    }

    private func setFavoriteButton(movie: Movie) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 0, weight: .regular, scale: .large)
        var image = UIImage()
        if crudUserListsVM.checkIfObjectIsInList(checkWatchList: false, movie: movieToShow!) == false {
            image = UIImage(systemName: "heart.slash.fill", withConfiguration: imageConfig)!
        } else {
            image = UIImage(systemName: "heart.fill", withConfiguration: imageConfig)!
            favoriteButtonTappedCounter = 2
        }
        DispatchQueue.main.async { [self] in
            favoriteButton.setImage(image, for: .normal)
        }
    }
    
    private func setWatchListButton(movie: Movie) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 0, weight: .regular, scale: .large)
        var image = UIImage()
        if crudUserListsVM.checkIfObjectIsInList(checkWatchList: true, movie: movieToShow!) == false {
            image = UIImage(systemName: "bookmark.slash.fill", withConfiguration: imageConfig)!
        } else {
            image = UIImage(systemName: "bookmark.fill", withConfiguration: imageConfig)!
            watchListButtonTappedCounter = 2
        }
        DispatchQueue.main.async { [self] in
            watchListButton.setImage(image, for: .normal)
        }
    }
    
    private func setRatingButton() {
        rateViewModel.getMovieRating() { [self] rating in
            guard let rating = rating else {return}
            self.movieToShow?.userRating = rating
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        let addToFavorite = favoriteButtonTappedCounter % 2 != 0 ? true : false
        if sessionViewModel.checkIfSessionIDExists() == false {
            performSession?.shouldStartSession()
        } else {
            crudUserListsVM.addToList(addToWatchList: false, addORDeleteFromList: addToFavorite, movie: movieToShow!) { [self] in
                setFavoriteButton(movie: movieToShow!)
            }
            favoriteButtonTappedCounter += 1
        }
    }
    
    @IBAction func watchListButtonPressed(_ sender: UIButton) {
        let addToWatchList = watchListButtonTappedCounter % 2 != 0 ? true : false
        if sessionViewModel.checkIfSessionIDExists() == false {
            performSession?.shouldStartSession()
        } else {
            crudUserListsVM.addToList(addToWatchList: true, addORDeleteFromList: addToWatchList, movie: movieToShow!) { [self] in
                setWatchListButton(movie: movieToShow!)
            }
        }
        watchListButtonTappedCounter += 1
    }
    
    @IBAction func userRating(_ sender: UIButton) {
        if sessionViewModel.checkIfSessionIDExists() == false {
            performSession?.shouldStartSession()
        } else {
            self.performRating?.shouldDisplayRatingVC()
        }
    }

    @IBAction func playButtonPressed(_ sender: UIButton) {
        if movieToShow?.videoKey != "" {
            performPlayVideo?.shouldPlayVideo(videoKey: movieToShow!.videoKey)
        }
    }
}
