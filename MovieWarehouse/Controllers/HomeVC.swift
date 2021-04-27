//
//  ViewController.swift
//  MovieWarehouse
//
//  Created by Kurs on 19/04/2021.
//

import UIKit

class HomeVC: UITableViewController {

    private let viewModel = HomeViewModel()
    private let activitySpinner = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        initActivitySpinner()
        fetchHomeScreen()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getResponsesCounter()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeScreenCell", for: indexPath) as! HomeScreenCell
        if indexPath.row != viewModel.getMovieResponsesCount() {
            cell.setMoviesArray(movies: viewModel.getMoviesFromMovieResponse(index: indexPath.row), changeCollection: false)
        } else {
            cell.setPersonArray(persons: viewModel.getPersonFromCastResponse(index: indexPath.row), changeCollection: true)
        }
        cell.setTableviewCellLabel(collectionViewLabel: viewModel.getListCategory(index: indexPath.row))
       return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }

    private func fetchHomeScreen() {
        viewModel.fetchMoviesForHomeScreen() { [self] () in
            DispatchQueue.main.async() {
                deInitActivitySpinner()
                self.tableView.reloadData()
            }
        }
    }

    private func initActivitySpinner() {
        self.tableView.backgroundView = activitySpinner
        activitySpinner.color = .white
        activitySpinner.startAnimating()
    }

    private func deInitActivitySpinner() {
        self.activitySpinner.stopAnimating()
    }
}
