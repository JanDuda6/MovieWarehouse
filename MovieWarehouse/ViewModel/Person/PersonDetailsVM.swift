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
    private var personCredits = [Movie]()

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
            self.personCredits.append(contentsOf: personCreditsResponse.cast)
            self.personCredits.append(contentsOf: personCreditsResponse.crew)
            for n in 0..<personCredits.count {
                personCredits[n].posterImage = imageService.getImageFromURL(url: imageService.profileURL(pathToImage: personCredits[n].posterPath))
                if personCredits[n].mediaType == "movie" {
                    personCredits[n].mediaType = "Movie"
                    personCredits[n].premiereDate = personCredits[n].releaseDate ?? ""
                } else {
                    personCredits[n].mediaType = "Tv Show"
                    personCredits[n].premiereDate = personCredits[n].firstAirDate ?? ""
                }
                personCredits[n].premiereDate = StringService.dateTrimm(date: personCredits[n].premiereDate)
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
