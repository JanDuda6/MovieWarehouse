//
//  SeeAllVC.swift
//  MovieWarehouse
//
//  Created by Kurs on 28/04/2021.
//

import Foundation
import UIKit

class SeeMoreVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let activitySpinner = ActivitySpinnerService()
    private let seeMoreVM = SeeAllVM()
    private var movieToShown: Movie?
    private var endpoint = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.delegate = self
        fetchMovies(endpoint: endpoint)
        activitySpinner.initCollectionViewSpinner(collectionView: self.collectionView)
    }

    func setEndpoint(endpoint: String) {
        self.endpoint = endpoint
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height) {
            fetchMovies(endpoint: endpoint)
        }
    }

    private func fetchMovies(endpoint: String) {
        seeMoreVM.fetchSeeMore(endpoint: endpoint) { [self] () in
            DispatchQueue.main.async() {
                activitySpinner.deInitActivitySpinner()
                self.collectionView.reloadData()
            }
        }
    }
}

//MARK: - Collection View
extension SeeMoreVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var collectionViewRow = 0
        if endpoint.contains("/movie/") || endpoint.contains("/tv/") {
            collectionViewRow = seeMoreVM.getMovies().count
        } else {
            collectionViewRow = seeMoreVM.getPersons().count
        }
        return collectionViewRow
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeeMoreCell", for: indexPath) as! HomeCollectionCell
        if endpoint.contains("/movie/") || endpoint.contains("/tv/") {
            cell.setCollectionViewMovieCell(movie: seeMoreVM.getMovies()[indexPath.row])
        } else {
            cell.setCollectionViewPersonCell(person: seeMoreVM.getPersons()[indexPath.row])
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
        if endpoint.contains("/movie/") || endpoint.contains("/tv/") {
            movieToShown = seeMoreVM.getMovies()[indexPath.row]
            performSegue(withIdentifier: "MovieDetailsSegue", sender: self)
        } else {
            let storyboard = UIStoryboard(name: "PersonDetailsStoryboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PersonDetails") as! PersonDetailsVC
            vc.setPerson(person: seeMoreVM.getPersons()[indexPath.row])
            self.navigationController?.show(vc, sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetailsSegue" {
            if let detailsVC = segue.destination as? MovieOrTVDetailsVC {
                detailsVC.setMovie(movie: self.movieToShown)
            }
        }
    }
}


