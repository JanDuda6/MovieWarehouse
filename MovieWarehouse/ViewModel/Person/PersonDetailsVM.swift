//
//  PErsonDetailsVM.swift
//  MovieWarehouse
//
//  Created by Kurs on 19/05/2021.
//

import Foundation
import UIKit

class PersonDetailsVM {
    private var apiService: APIService
    private var imageService: ImageService
    private var person: Person?
    private var personCredits = Set<Movie>()

    init(apiService: APIService = APIService(), imageService: ImageService = ImageService()) {
        self.apiService = apiService
        self.imageService = imageService
    }
    
    func setPerson(person: Person) {
        self.person = person
    }

    func fetchData(completion: @escaping () -> Void) {
        guard let person = person else { return }
        let endpoint = Endpoints.personDetails.replacingOccurrences(of: "{person_id}", with: String(person.id))
        apiService.performHTTPRequest(request: [endpoint]) { [self] (data, _, _) in
            var personFromData = apiService.parsePersonData(data: data)
            personFromData.profileImage = person.profileImage
            self.person = personFromData
            completion()
        }
    }

    func fetchPersonCredits(completion: @escaping () -> Void) {
        guard let person = person else { return }
        let endpoint = Endpoints.personCredits.replacingOccurrences(of: "{person_id}", with: String(person.id))
        apiService.performHTTPRequest(request: [endpoint]) { [self] (data, _, _) in
            let personCreditsResponse = apiService.parsePersonCastData(data: data)

            var movieArray = [Movie]()
            movieArray.append(contentsOf: personCreditsResponse.cast)
            movieArray.append(contentsOf: personCreditsResponse.crew)

            for n in 0..<movieArray.count {
                movieArray[n].posterImage = imageService.getImageFromURL(url: imageService.profileURL(pathToImage: movieArray[n].posterPath))
                if movieArray[n].mediaType == "movie" {
                    movieArray[n].mediaType = "Movie"
                    movieArray[n].premiereDate = movieArray[n].releaseDate ?? ""
                } else {
                    movieArray[n].mediaType = "Tv Show"
                    movieArray[n].premiereDate = movieArray[n].firstAirDate ?? ""
                }
                movieArray[n].premiereDate = StringService.dateTrimm(date: movieArray[n].premiereDate)
                personCredits.insert(movieArray[n])
            }
            completion()
        }
    }
    func getPerson() -> Person {
        return self.person!
    }

    func getPersonCredits() -> [Movie] {
        let sortedPersonCredits = self.personCredits.sorted { $0.premiereDate > $1.premiereDate }
        return sortedPersonCredits
    }

}
