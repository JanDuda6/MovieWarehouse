//
//  ViewController.swift
//  MovieWarehouse
//
//  Created by Kurs on 19/04/2021.
//

import UIKit

class HomeVC: UITableViewController {
    private var viewModel = HomeScreenMoviesOrTVVM()
    private let activitySpinner = ActivitySpinnerService()
    private var responseURL = ""
    private var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        activitySpinner.initTableViewSpinner(tableView: self.tableView)
        fetchHomeScreen()
    }

    private func fetchHomeScreen() {
        let moviesOrTV = self.tabBarController?.tabBar.selectedItem?.title == "TV" ? false : true
        viewModel.fetchForHomeScreen(moviesOrTV: moviesOrTV) { [self] () in
            DispatchQueue.main.async() {
                activitySpinner.deInitActivitySpinner()
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - TableView
extension HomeVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getResponsesCounter()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeScreenCell", for: indexPath) as! HomeScreenCell
            if indexPath.row != viewModel.getMovieOrTVResponsesCount() {
                let movies = viewModel.getMoviesOrTVShows(index: indexPath.row)
                cell.setMovieOrTVArray(movies: movies, changeCollection: false)
                cell.setResponseURL(url: viewModel.getMovieOrTVResponseURL(index: indexPath.row))
            } else {
                cell.setPersonArray(persons: viewModel.getPersonFromCastResponse(index: indexPath.row), changeCollection: true)
                cell.setResponseURL(url: viewModel.getPersonResponseURL(index: indexPath.row))
            }
        cell.setTableviewCellLabel(collectionViewLabel: viewModel.getListCategory(index: indexPath.row))
        cell.performSegueDelegate = self
        self.tableView.rowHeight = 370
        return cell
    }
}

//MARK: - Perform Segue Delegate
extension HomeVC: PerformSegueDelegate {
    func didPerformMovieDetailsSegue(movie: Movie) {
        self.movie = movie
        performSegue(withIdentifier: "MovieDetailsSegue", sender: self)
    }

    func didPerformPersonDetailsSegue(person: Person) {
        let storyboard = UIStoryboard(name: "PersonDetailsStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PersonDetails") as! PersonDetailsVC
        vc.setPerson(person: person)
        self.navigationController?.show(vc, sender: nil)
    }

    func didPerformSegueSeeMore(responseURL: String) {
        self.responseURL = responseURL
        self.performSegue(withIdentifier: "SeeMoreSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeMoreSegue" {
            if let seeMoreVC = segue.destination as? SeeMoreVC {
                seeMoreVC.setEndpoint(endpoint: self.responseURL)
            }
        }
        if segue.identifier == "MovieDetailsSegue" {
            if let movieOrTVeDetailsVC = segue.destination as? MovieOrTVDetailsVC {
                movieOrTVeDetailsVC.setMovie(movie: self.movie)
            }
        }
    }
}
