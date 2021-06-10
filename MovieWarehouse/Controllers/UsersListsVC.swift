//
//  UserListsVC.swift
//  MovieWarehouse
//
//  Created by Kurs on 31/05/2021.
//

import Foundation
import UIKit
import AuthenticationServices

class UsersListsVC: UIViewController, ASWebAuthenticationPresentationContextProviding {
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = AllUsersListsVM()
    private let sessionVM = SessionVM()
    private var movieLists = true
    var authSession: ASWebAuthenticationSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        registerCell()
    }

    override func viewDidAppear(_ animated: Bool) {
        checkIfSessionExists()
    }

    @IBAction func moviesOrTVSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            movieLists = true
            viewModel.setMoviesOrTvLists(moviesLists: movieLists)
            fetchData()
        case 1:
            movieLists = false
            viewModel.setMoviesOrTvLists(moviesLists: movieLists)
            fetchData()
        default:
            break
        }
    }

    @IBAction func categorySegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.setCategory(index: 0)
           fetchData()
        case 1:
            viewModel.setCategory(index: 1)
            fetchData()
        case 2:
            viewModel.setCategory(index: 2)
            fetchData()
        default:
            break
        }
    }

    func fetchData() {
        viewModel.reuseMoviesArray()
        viewModel.fetchList {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func checkIfSessionExists() {
        if sessionVM.checkIfSessionIDExists() == false {
            let scheme = "moviewarehouse"
            let endpoint = sessionVM.getAuthEndpoint()
            guard let authURL = URL(string: endpoint) else { return }
            authSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: scheme) { [self] callbackURL, error in
                sessionVM.getSessionID()
            }
            authSession.presentationContextProvider = self
            authSession.start()
        } else {
            fetchData()
        }
    }
}

//MARK: - Table View
extension UsersListsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getData().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KnownForCell", for: indexPath) as! KnownForCell
        cell.setKnownForCell(movie: viewModel.getData()[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as! MovieOrTVDetailsVC
        vc.setMovie(movie: viewModel.getData()[indexPath.row])
        self.navigationController?.show(vc, sender: nil)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height) {
            fetchData()
        }
    }

    func registerCell() {
        tableView.register(UINib(nibName: "KnownForCell", bundle: nil), forCellReuseIdentifier: "KnownForCell")
    }
}

extension UsersListsVC {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}
