//
//  ProtocolSegueDelegates.swift
//  MovieWarehouse
//
//  Created by Kurs on 18/05/2021.
//

import Foundation

protocol PerformSegueDelegate {
    func didPerformSegueSeeMore(responseURL: String)
    func didPerformMovieDetailsSegue(movie: Movie)
    func didPerformPersonDetailsSegue(person: Person)
}

protocol PerformSessionDeleagte {
    func shouldStartSession()
}

protocol PerformRatingDelegate {
    func shouldDisplayRatingVC()
}

