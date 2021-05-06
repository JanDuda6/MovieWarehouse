//
//  ViewController.swift
//  MovieWarehouse
//
//  Created by Kurs on 19/04/2021.
//

import UIKit

class HomeVC: UITableViewController {

    private var viewModel = HomeScreenMoviesVM()
    private let activitySpinner = UIActivityIndicatorView(style: .medium)
    private var responseURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        initActivitySpinner()
        changeViewModelClass()
        fetchHomeScreen()
    }

    private func changeViewModelClass() {
        if self.tabBarController?.tabBar.selectedItem?.title == "TV" {
            self.viewModel = HomeScreenTVVM()
        }
    }

    private func fetchHomeScreen() {
        viewModel.fetchForHomeScreen() { [self] () in
            DispatchQueue.main.async() {
                deInitActivitySpinner()
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - Table view
extension HomeVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getResponsesCounter()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeScreenCell", for: indexPath) as! HomeScreenCell
        let tabBarItem = self.tabBarController?.tabBar.selectedItem?.title

        switch tabBarItem {
        case "TV":
            let tvShows = viewModel.getMoviesOrTVShows(index: indexPath.row)
            cell.setTVShowArray(tv: tvShows.0!, changeCollection: true)
            cell.setResponseURL(url: viewModel.getMovieOrTVResponseURL(index: indexPath.row))
            cell.setTableviewCellLabel(collectionViewLabel: viewModel.getListCategory(index: indexPath.row))
        default:
            if indexPath.row != viewModel.getMovieResponsesCount() {
                let movies = viewModel.getMoviesOrTVShows(index: indexPath.row)
                cell.setMoviesArray(movies: movies.1!, changeCollection: false)
                cell.setResponseURL(url: viewModel.getMovieOrTVResponseURL(index: indexPath.row))
            } else {
                cell.setPersonArray(persons: viewModel.getPersonFromCastResponse(index: indexPath.row), changeCollection: true)
                cell.setResponseURL(url: viewModel.getPersonResponseURL(index: indexPath.row))
            }
            cell.setTableviewCellLabel(collectionViewLabel: viewModel.getListCategory(index: indexPath.row))
        }
        cell.performSegueDelegate = self
        self.tableView.rowHeight = cell.frame.height
        return cell
    }
}

//MARK: - Perform Segue Delegate
extension HomeVC: PerformSegueDelegate {
    func didPerformSegue(responseURL: String) {
        self.responseURL = responseURL
        self.performSegue(withIdentifier: "SeeMoreSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeMoreSegue" {
            if let seeMoreVC = segue.destination as? SeeMoreVC {
                seeMoreVC.endpoint = self.responseURL
            }
        }
    }
}

//MARK: - Activity Spinner
extension HomeVC {
    private func initActivitySpinner() {
        self.tableView.backgroundView = activitySpinner
        activitySpinner.color = .gray
        activitySpinner.startAnimating()
    }

    private func deInitActivitySpinner() {
        self.activitySpinner.stopAnimating()
    }
}
