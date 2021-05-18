//
//  MovieDetails.swift
//  MovieWarehouse
//
//  Created by Kurs on 07/05/2021.
//

import Foundation
import UIKit

class MovieOrTVDetailsVC: UITableViewController {
    private var movieToShow: Movie?
    private var tvToShow: TV?
    private var viewModel = MovieDetailsVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        changeViewModelClass()
    }

    private func registerCells() {
        tableView.register(UINib(nibName: "HeaderDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "Header")
        tableView.register(UINib(nibName: "MovieOverviewCell", bundle: nil), forCellReuseIdentifier: "MovieOverviewCell")
        tableView.register(UINib(nibName: "CastAndCrewCollectionView", bundle: nil), forCellReuseIdentifier: "CastAndCrewCell")
    }

    private func changeViewModelClass() {
        if movieToShow == nil {
            viewModel = TVDetailsVM()
            viewModel.setObject(movie: nil, tv: tvToShow)
            fetchDetails()
        } else {
            viewModel.setObject(movie: movieToShow, tv: nil)
            fetchDetails()
        }
    }

    func setTV(tv: TV?) {
        self.tvToShow = tv
    }

    func setMovie(movie: Movie?) {
        self.movieToShow = movie
    }
}

//MARK: - TableView
extension MovieOrTVDetailsVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = viewModel.getObject()
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Header", for: indexPath) as! HeaderDetailsTableViewCell
            movieToShow != nil ?   cell.setMovieCell(movie: object.0!) : cell.setTVCell(tv: object.1!)
            self.tableView.rowHeight = UITableView.automaticDimension
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieOverviewCell", for: indexPath) as! ObjectOverviewCell
            movieToShow != nil ? cell.setCell(overview: object.0!.overview) : cell.setCell(overview: object.1!.overview)
            self.tableView.rowHeight = UITableView.automaticDimension
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CastAndCrewCell", for: indexPath) as! CastAndCrewCollectionView
            cell.setCellLabel(cellLabelName: "Cast & Crew")
            cell.setCastAndCrew(castAndCrew: viewModel.getCastAndCrew())
            self.tableView.rowHeight = 180
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CastAndCrewCell", for: indexPath) as! CastAndCrewCollectionView
            let providers = viewModel.getWatchProviders()
            if providers.count != 0 {
                cell.setCellLabel(cellLabelName: "Where to watch")
                cell.setProviders(providers: providers)
                self.tableView.rowHeight = 120
            } else {
                self.tableView.rowHeight = 0
            }
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CastAndCrewCell", for: indexPath) as! CastAndCrewCollectionView
            let recommendations = viewModel.getRecommendation()
            cell.setCellLabel(cellLabelName: "Recommended movies")
            movieToShow != nil ? cell.setMovies(movies: recommendations.0!) : cell.setTV(tvShows: recommendations.1!)
            self.tableView.rowHeight = 270
            return cell
        default:
            return UITableViewCell()
        }
    }
}

//MARK: - Fetch data
extension MovieOrTVDetailsVC {
    private func fetchDetails() {
        viewModel.fetchGenre() { () in
        }
        viewModel.fetchCredits() { [self] () in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.fetchProviders() { [self] () in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.fetchRecommended() { [self] () in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

