//
//  MovieDetails.swift
//  MovieWarehouse
//
//  Created by Kurs on 07/05/2021.
//

import Foundation
import UIKit
import AuthenticationServices

class MovieOrTVDetailsVC: UITableViewController, ASWebAuthenticationPresentationContextProviding {
    private var movieToShow: Movie?
    private var personToShow: Person?
    private var viewModel = MovieOrTVDetailsVM()
    private var sessionViewModel = SessionVM()
    private var playerVM = PlayerVM()
    var authSession: ASWebAuthenticationSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        changeViewModelClass()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }

    private func registerCells() {
        tableView.register(UINib(nibName: "HeaderDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "Header")
        tableView.register(UINib(nibName: "MovieOverviewCell", bundle: nil), forCellReuseIdentifier: "MovieOverviewCell")
        tableView.register(UINib(nibName: "CastAndCrewCollectionView", bundle: nil), forCellReuseIdentifier: "CastAndCrewCell")
    }

    private func changeViewModelClass() {
        viewModel.setMovieOrTV(movie: movieToShow!)
        playerVM.setMovieID(movie: movieToShow!)
        movieToShow?.name != nil ? fetchDetails(moviesOrTV: false) : fetchDetails(moviesOrTV: true)
    }

    func setMovie(movie: Movie?) {
        self.movieToShow = movie
    }
}

extension MovieOrTVDetailsVC: PerformSessionDeleagte {
    func shouldStartSession() {
        let scheme = "moviewarehouse"
        let endpoint = sessionViewModel.getAuthEndpoint()
        guard let authURL = URL(string: endpoint) else { return }
        authSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: scheme) { [self] callbackURL, error in
            sessionViewModel.getSessionID()
        }
        authSession.presentationContextProvider = self
        authSession.start()
    }
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
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
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Header", for: indexPath) as! HeaderDetailsTableViewCell
            cell.setCell(movie: viewModel.getObject())
            cell.setGenres(genre: viewModel.getGenres())
            cell.setVideoKey(videoKey: playerVM.getVideoKey())
            cell.performSession = self
            cell.performRating = self
            cell.performPlayVideo = self
            self.tableView.rowHeight = UITableView.automaticDimension
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieOverviewCell", for: indexPath) as! ObjectOverviewCell
            cell.setCell(overview: viewModel.getObject().overview ?? "")
            self.tableView.rowHeight = UITableView.automaticDimension
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CastAndCrewCell", for: indexPath) as! CastAndCrewCollectionView
            if viewModel.getCastAndCrew().count == 0 {
                cell.setCellLabel(cellLabelName: "")
                self.tableView.rowHeight = 0
            } else {
                cell.setCellLabel(cellLabelName: "Cast & Crew")
                cell.setCastAndCrew(castAndCrew: viewModel.getCastAndCrew())
                self.tableView.rowHeight = 180
            }
            cell.performSegueDelegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CastAndCrewCell", for: indexPath) as! CastAndCrewCollectionView
            let providers = viewModel.getWatchProviders()
            if providers.count != 0 {
                cell.setCellLabel(cellLabelName: "Where to watch")
                cell.setProviders(providers: providers)
                cell.performSegueDelegate = self
                self.tableView.rowHeight = 120
            } else {
                self.tableView.rowHeight = 0
            }
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CastAndCrewCell", for: indexPath) as! CastAndCrewCollectionView
            let recommendations = viewModel.getRecommendation()
            if recommendations.count != 0 {
                cell.setCellLabel(cellLabelName: "Recommended movies")
                cell.setMovies(movies: recommendations)
                cell.performSegueDelegate = self
                self.tableView.rowHeight = 270
            } else {
                cell.setCellLabel(cellLabelName: "")
                self.tableView.rowHeight = 0
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

//MARK: - Fetch data
extension MovieOrTVDetailsVC {
    private func fetchDetails(moviesOrTV: Bool) {
        viewModel.fetchGenre(moviesOrTV: moviesOrTV) { [self] () in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.fetchCredits(moviesOrTV: moviesOrTV) { [self] () in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.fetchProviders(moviesOrTV: moviesOrTV) { [self] () in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.fetchRecommended(moviesOrTV: moviesOrTV) { [self] () in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        playerVM.fetchVideoKey {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
//MARK: - Segue delegates
extension MovieOrTVDetailsVC: PerformSegueDelegate {
    func didPerformSegueSeeMore(responseURL: String) {}

    func didPerformMovieDetailsSegue(movie: Movie) {
        self.movieToShow = movie
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as! MovieOrTVDetailsVC
        vc.setMovie(movie: movieToShow)
        self.navigationController?.show(vc, sender: nil)
    }

    func didPerformPersonDetailsSegue(person: Person) {
        let storyboard = UIStoryboard(name: "PersonDetailsStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PersonDetails") as! PersonDetailsVC
        vc.setPerson(person: person)
        self.navigationController?.show(vc, sender: nil)
    }
}
//MARK: - Rating delegates
extension MovieOrTVDetailsVC: PerformRatingDelegate {
    func shouldDisplayRatingVC() {
        let storyboard = UIStoryboard(name: "RateObject", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ratingVC") as! RateVC
        vc.setMovie(movie: movieToShow!)
        self.navigationController?.show(vc, sender: nil)
    }
}

//MARK: - Play Video
extension MovieOrTVDetailsVC: PerformPlayVideoDelegate {
    func shouldPlayVideo(videoKey: String) {
        let storyboard = UIStoryboard(name: "PlayerView", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PlayerView") as! PlayerVC
        vc.setKey(key: videoKey)
        self.navigationController?.show(vc, sender: nil)
    }


}

