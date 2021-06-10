//
//  ListsVM.swift
//  MovieWarehouse
//
//  Created by Kurs on 10/06/2021.
//

import Foundation

class CRUDUserListsVM {
    private var apiService: APIService
    private var requestToken = ""
    private var sessionID = ""

    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }

    func addToList(addToWatchList: Bool, addORDeleteFromList: Bool, movie: Movie, completion: @escaping () -> Void) {
        let mediaType = movie.name == nil ? "movie" : "tv"
        let favorite: AccountList
        let endpoint: String
        if addToWatchList == true {
            endpoint = createEndpoint(endpoint: PostEndpoints.postWatchList)
            favorite = AccountList(mediaType: mediaType, mediaID: movie.id, watchList: addORDeleteFromList)
        } else {
            endpoint = createEndpoint(endpoint: PostEndpoints.postMarkAsFavorite)
            favorite = AccountList(mediaType: mediaType, mediaID: movie.id, favorite: addORDeleteFromList)
        }
        addObjectToUserDefaults(addToWatchList: addToWatchList, addToList: addORDeleteFromList, movie: movie)
        let data = apiService.parseMarkAsFavoriteToData(modelToUpload: favorite)
        apiService.performPostHTTPRequest(data: data, stringURL: endpoint) { [self] data in
            let alert = apiService.parseAlert(data: data)
            print(alert)
            completion()
        }
    }

   private func addObjectToUserDefaults(addToWatchList: Bool, addToList: Bool, movie: Movie) {
        let arrayName: String
        if addToWatchList == true {
            arrayName = movie.name == nil ? "watchListMovies" : "watchListTV"
        } else {
            arrayName = movie.name == nil ? "favoriteMovies" : "favoriteTV"
        }
        if var movieArray = UserDefaults.standard.array(forKey: arrayName) as? Array<Int> {
            if addToList == true {
                movieArray.append(movie.id)
            } else {
                movieArray = movieArray.filter(){ $0 != movie.id }
            }
            UserDefaults.standard.setValue(movieArray, forKey: arrayName)
        } else {
            let movieArray = [movie.id]
            UserDefaults.standard.setValue(movieArray, forKey: arrayName)
        }
    }

    func checkIfObjectIsInList(checkWatchList: Bool, movie: Movie) -> Bool {
        var objectInArray = false
        let arrayName: String
        if checkWatchList == true {
            arrayName = movie.name == nil ? "watchListMovies" : "watchListTV"
        } else {
            arrayName = movie.name == nil ? "favoriteMovies" : "favoriteTV"
        }
        if let movieArray = UserDefaults.standard.array(forKey: arrayName) as? Array<Int> {
            if movieArray.contains(movie.id){
                objectInArray = true
            } else {
                objectInArray = false
            }
        }
        return objectInArray
    }

   private func createEndpoint(endpoint: String) -> String {
        let sessionID = UserDefaults.standard.string(forKey: "sessionID")
        let accountID = UserDefaults.standard.string(forKey: "accountID")
        let endpoint = endpoint + "&session_id=\(sessionID!)"
        let endpointWithAccountID = endpoint.replacingOccurrences(of: "{account_id}", with: accountID!)
        return endpointWithAccountID
    }
}
