//
//  RateVC.swift
//  MovieWarehouse
//
//  Created by Kurs on 09/06/2021.
//

import Foundation
import UIKit

class RateVC: UIViewController {

    @IBOutlet private weak var moviePoster: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private var stars: [UIButton]!

    private var movie: Movie?
    private let ratingVM = RateObjectVM()
    private var fillStarImage = UIImage()
    private var starImage = UIImage()
    private var rating = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        ratingVM.setMovie(movie: movie!)
        setImageConfiguration()
        setPosterAndTitle()
        setStarImageATag()
        setActualRating()
    }

    @IBAction func setRating(_ sender: UIButton) {
        setStarImageNewRating(senderTag: sender.tag)
    }

    @IBAction func rateButtonPressed(_ sender: UIButton) {
        ratingVM.setRating(rating: rating)
        ratingVM.sendRatingToApi(rating: rating)
    }

    @IBAction func deleteRatingPressed(_ sender: UIButton) {
        ratingVM.deleteRating()
        deleteSFilledStars()
    }

    func setMovie(movie: Movie) {
        self.movie = movie
    }

    private func setPosterAndTitle() {
        self.moviePoster.image = movie?.posterImage
        if movie?.title == nil {
            self.movieTitle.text = movie?.name
        } else {
            self.movieTitle.text = movie?.title
        }
    }

    private func setActualRating() {
        ratingVM.getMovieRating() { [self] rating in
            guard let rating = rating else { return }
            for star in stars {
                if star.tag <= rating {
                    star.setImage(fillStarImage, for: .normal)
                }
            }
        }
    }

    private func deleteSFilledStars() {
        for star in stars {
            star.setImage(starImage, for: .normal)
        }
    }

    private func setStarImageATag() {
        var counter = 1
        for star in stars {
            star.tag = counter
            counter += 1
        }
    }

    private func setStarImageNewRating(senderTag: Int) {
        self.rating = senderTag
        for star in stars {
            if star.tag <= senderTag {
                star.setImage(fillStarImage, for: .normal)
            } else {
                star.setImage(self.starImage, for: .normal)
            }
        }
    }

    private func setImageConfiguration() {
        let starImageConfig = UIImage.SymbolConfiguration(pointSize: 0, weight: .regular, scale: .large)
        self.fillStarImage = UIImage(systemName: "star.fill", withConfiguration: starImageConfig)!
        self.starImage = UIImage(systemName: "star", withConfiguration: starImageConfig)!
    }
}
