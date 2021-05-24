//
//  PersonDetailsVC.swift
//  MovieWarehouse
//
//  Created by Kurs on 19/05/2021.
//

import Foundation
import UIKit

class PersonDetailsVC: UIViewController {
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = PersonDetailsVM()
    private var segmentControllerChanged = true
    private var person: Person?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        registerCells()
        fetchData()
    }

    func setPerson(person: Person) {
        self.person = person
    }

    @IBAction func segmentPushed(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.segmentControllerChanged = true
            self.tableView.reloadData()
        case 1:
            self.segmentControllerChanged = false
            self.tableView.reloadData()
        default:
            break
        }
    }

    private func registerCells() {
        tableView.register(UINib(nibName: "BiographyCell", bundle: nil), forCellReuseIdentifier: "BiographyCell")
        tableView.register(UINib(nibName: "KnownForCell", bundle: nil), forCellReuseIdentifier: "KnownForCell")
    }

    private func fetchData() {
        viewModel.setPerson(person: self.person!)
        viewModel.fetchData() { [self] in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.fetchPersonCredits() {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    private func setViewHeader(person: Person) {
        self.personImage.image = person.profileImage
        self.nameLabel.text = person.name
        self.departmentLabel.text = person.knownForDepartment
        self.birthdayLabel.text = StringService.dateOfBirthTrimm(birthday: person.birthday ?? "", deathDay: person.deathDay ?? "")
        self.personImage.layer.cornerRadius = personImage.frame.height / 2
    }
}

//MARK: - Table View
extension PersonDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControllerChanged == true {
            return 1
        } else {
            return viewModel.getPersonCredits().count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.setViewHeader(person: viewModel.getPerson())
        if segmentControllerChanged == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BiographyCell", for: indexPath) as! BiographyCell
            cell.setBiographyText(person: viewModel.getPerson())
            return cell
        } else {
            let movies = viewModel.getPersonCredits()
            let cell = tableView.dequeueReusableCell(withIdentifier: "KnownForCell", for: indexPath) as! KnownForCell
            cell.setKnownForCell(movie: movies[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movies = viewModel.getPersonCredits()[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as! MovieOrTVDetailsVC
        vc.setMovie(movie: movies)
        self.navigationController?.show(vc, sender: nil)
    }
}
