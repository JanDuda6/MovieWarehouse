//
//  SeeAllVC.swift
//  MovieWarehouse
//
//  Created by Kurs on 28/04/2021.
//

import Foundation
import UIKit

class SeeMoreVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let seeMoreVM = SeeAllVM()
    private var movieToShown: Movie?
    private var tvToShown: TV?
    private var endpoint = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.delegate = self
        fetchMovies(endpoint: endpoint)
    }

    func setEndpoint(endpoint: String) {
        self.endpoint = endpoint
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var collectionViewRow = 0
        if endpoint.contains("/tv/") {
            collectionViewRow = seeMoreVM.getTVShows().count
        }
        if endpoint.contains("/movie/") {
            collectionViewRow = seeMoreVM.getMovies().count
        }
        if endpoint.contains("/person/") {
            collectionViewRow = seeMoreVM.getPersons().count
        }
        return collectionViewRow
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeeMoreCell", for: indexPath) as! HomeCollectionCell
        if endpoint.contains("/tv/") {
            cell.setCollectionViewCell(image: seeMoreVM.getTVShows()[indexPath.row].posterImage, title: seeMoreVM.getTVShows()[indexPath.row].title)
        }
        if endpoint.contains("/movie/") {
            cell.setCollectionViewCell(image: seeMoreVM.getMovies()[indexPath.row].posterImage, title: seeMoreVM.getMovies()[indexPath.row].title)
        }
        if endpoint.contains("/person/") {
            cell.setCollectionViewCell(image: seeMoreVM.getPersons()[indexPath.row].profileImage, title: seeMoreVM.getPersons()[indexPath.row].name)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        var width: CGFloat = 0
        switch screenWidth {
        case 375...428:
             width = (self.collectionView.bounds.width - 20)/3
        case 429...834:
            width = (self.collectionView.bounds.width - 25)/4
        default:
             width = (self.collectionView.bounds.width - 30)/5
        }
        let height  = width * 1.7
        return CGSize(width: width, height: height)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if endpoint.contains("/tv/") {
            tvToShown = seeMoreVM.getTVShows()[indexPath.row]
            performSegue(withIdentifier: "MovieDetailsSegue", sender: self)
        }
        if endpoint.contains("/movie/") {
            movieToShown = seeMoreVM.getMovies()[indexPath.row]
            performSegue(withIdentifier: "MovieDetailsSegue", sender: self)
        }

        if endpoint.contains("/person/") {
            print(seeMoreVM.getPersons()[indexPath.row])
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetailsSegue" {
            if let detailsVC = segue.destination as? MovieOrTVDetailsVC {
                detailsVC.setMovie(movie: self.movieToShown)
                detailsVC.setTV(tv: self.tvToShown)
            }
        }
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height) {
            fetchMovies(endpoint: endpoint)
        }
    }

    private func fetchMovies(endpoint: String) {
        seeMoreVM.fetchSeeMore(endpoint: endpoint) { [self] () in
            DispatchQueue.main.async() {
                self.collectionView.reloadData()
            }
        }
    }
}
