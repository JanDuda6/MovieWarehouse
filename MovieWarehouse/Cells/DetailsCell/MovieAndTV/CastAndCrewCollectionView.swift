//
//  CastAndCrewCollectionView.swift
//  MovieWarehouse
//
//  Created by Kurs on 11/05/2021.
//

import UIKit

class CastAndCrewCollectionView: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var cellLabel: UILabel!
    
    private var castAndCrew = [Person]()
    private var providers = Set<Provider>()
    private var movies = [Movie]()

    var performSegueDelegate: PerformSegueDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        registerCells()
        addTapGestureToCollectionView()
    }

    func setCellLabel(cellLabelName: String) {
        self.cellLabel.text = cellLabelName
    }

    func setCastAndCrew(castAndCrew: [Person]) {
        self.castAndCrew = castAndCrew
    }

    func setProviders(providers: Set<Provider>) {
        self.providers = providers
    }

    func setMovies(movies: [Movie]) {
        self.movies = movies
    }

    private func registerCells() {
        self.collectionView.register(UINib(nibName: "CastAndCrewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CastAndCrewCVCell")
        self.collectionView.register(UINib(nibName: "ProvidersCell", bundle: nil), forCellWithReuseIdentifier: "ProvidersCell")
    }
}
//MARK: - CollectionView

extension CastAndCrewCollectionView {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movies.count != 0 {
            return movies.count
        }
        let numberOfItems = castAndCrew.count == 0 ? providers.count : castAndCrew.count
        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if castAndCrew.count != 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastAndCrewCVCell", for: indexPath) as! CastAndCrewCollectionViewCell
            castAndCrew[indexPath.row].job == nil ? cell.setCell(image: castAndCrew[indexPath.row].profileImage, name: castAndCrew[indexPath.row].name, characterName: castAndCrew[indexPath.row].characterName!) : cell.setCell(image: castAndCrew[indexPath.row].profileImage, name: castAndCrew[indexPath.row].name, characterName: castAndCrew[indexPath.row].job!)
            return cell
        }
        if providers.count != 0 {
            let providersArray = Array(providers)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProvidersCell", for: indexPath) as! ProvidersCell
            cell.setCell(providerImage: providersArray[indexPath.row].providerLogoImage)
            cell.setImageConstraintsForProviders()
            return cell
        }
        if movies.count != 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProvidersCell", for: indexPath) as! ProvidersCell
            cell.setCell(providerImage: movies[indexPath.row].posterImage)
            cell.setImageConstraintsForPosters()
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let screenWidth = UIScreen.main.bounds.size.width
        var width: CGFloat = 0
        switch screenWidth {
        case 375...428:
            width = (self.collectionView.bounds.width)/3
        case 429...834:
            width = (self.collectionView.bounds.width)/4
        default:
            width = (self.collectionView.bounds.width)/5
        }
        var height = self.collectionView.frame.height
        if providers.count != 0 || castAndCrew.count != 0 {
            height = self.collectionView.frame.height
        } else {
            height = width * 1.7
        }
        return CGSize(width: width, height: height)
    }

    override func prepareForReuse() {
        collectionView.contentOffset = .zero
        collectionView.reloadData()
    }
}
//MARK: - Tap Gesture
extension CastAndCrewCollectionView {
    private func addTapGestureToCollectionView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        collectionView.addGestureRecognizer(tap)
        collectionView.isUserInteractionEnabled = true
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            if movies.count != 0 {
                performSegueDelegate?.didPerformMovieDetailsSegue(movie: movies[indexPath.row])
            }

            if castAndCrew.count != 0 {
                performSegueDelegate?.didPerformPersonDetailsSegue(person: castAndCrew[indexPath.row])
            }
        }
    }
}
