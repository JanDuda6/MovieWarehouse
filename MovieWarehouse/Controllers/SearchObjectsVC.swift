//
//  SearchObjectsVC.swift
//  MovieWarehouse
//
//  Created by Kurs on 24/05/2021.
//

import Foundation
import UIKit

class SearchObjectsVC : UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private let activitySpinner = ActivitySpinnerService()
    private let viewModel = SearchObjectsVM()
    private var segmentToFind = "Movie"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        registerCell()
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        prepareSearchBar()
        switch sender.selectedSegmentIndex {
        case 0:
            self.segmentToFind = "Movie"
        case 1:
            self.segmentToFind = "Person"
        case 2:
            self.segmentToFind = "TV"
        default:
            break
        }
    }

    func prepareSearchBar() {
        viewModel.setEmptyMovieAndPersonArray()
        self.tableView.reloadData()
        searchBar.text = ""
        activitySpinner.deInitActivitySpinner()
    }
}

//MARK: - Search delegate
extension SearchObjectsVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.setEmptyMovieAndPersonArray()
        self.tableView.reloadData()
        activitySpinner.initTableViewSpinner(tableView: self.tableView)
        self.searchBar.endEditing(true)
        if searchBar.text == "" { return }
        viewModel.fetchDataFromSearchBar(query: searchBar.text!, segment: segmentToFind) {
            DispatchQueue.main.async { [self] in
                activitySpinner.deInitActivitySpinner()
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - Table View
extension SearchObjectsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = segmentToFind == "Person" ? viewModel.getPersonResults().count : viewModel.getMovieResult().count
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentToFind == "Person" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonSearchCell", for: indexPath) as! PersonSearchCell
            cell.setCell(person: viewModel.getPersonResults()[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "KnownForCell", for: indexPath) as! KnownForCell
            cell.setKnownForCell(movie: viewModel.getMovieResult()[indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentToFind == "Movie" || segmentToFind == "TV" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as! MovieOrTVDetailsVC
            vc.setMovie(movie: viewModel.getMovieResult()[indexPath.row])
            self.navigationController?.show(vc, sender: nil)
        } else {
            let storyboard = UIStoryboard(name: "PersonDetailsStoryboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PersonDetails") as! PersonDetailsVC
            vc.setPerson(person: viewModel.getPersonResults()[indexPath.row])
            self.navigationController?.show(vc, sender: nil)
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height) {
            viewModel.fetchDataFromSearchBar(query: searchBar.text!, segment: segmentToFind) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    func registerCell() {
        tableView.register(UINib(nibName: "PersonSearchCell", bundle: nil), forCellReuseIdentifier: "PersonSearchCell")
        tableView.register(UINib(nibName: "KnownForCell", bundle: nil), forCellReuseIdentifier: "KnownForCell")
    }
}
