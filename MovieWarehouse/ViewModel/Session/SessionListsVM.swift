//
//  SessionListsVM.swift
//  MovieWarehouse
//
//  Created by Kurs on 27/05/2021.
//

import Foundation
import UIKit

class SessionListsVM {
    private var apiService: APIService
    private var requestToken = ""
    private var sessionID = ""

    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }

    func createRequestToken() {
        apiService.performGetHTTPRequest(request: [GetEndpoints.getSessionRequestToken]) { [self] data, _, _ in
            requestToken = apiService.parseRequestToken(data: data).requestToken
        }
    }

    func authorizeRequestToken(requestToken: String) -> String {
        return PostEndpoints.authenticateToken.replacingOccurrences(of: "{REQUEST_TOKEN}", with: requestToken)
    }

    func getRequestToken() -> String {
        return requestToken
    }

    func getSessionID(requestToken: String) {
        let requestToken = RequestToken(requestToken: requestToken)
        let data = apiService.parseRequestTokenToData(modelToUpload: requestToken)
        apiService.performPostHTTPRequest(data: data, stringURL: PostEndpoints.getSessionID) { [self] data in
            let sessionID = apiService.parseSession(data: data).sessionID
            UserDefaults.standard.set(sessionID, forKey: "sessionID")
            let accountDetailsEndpoint = GetEndpoints.getAccountDetails + "&session_id=\(sessionID)"
            apiService.performGetHTTPRequest(request: [accountDetailsEndpoint]) { data, _, _ in
                let accountDetails = apiService.parseAccountDetails(data: data)
                UserDefaults.standard.set(accountDetails.id, forKey: "accountID")
            }
        }
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
        addMovieToFavoriteUsersDefaults(addToWatchList: addToWatchList, addToList: addORDeleteFromList, movie: movie)
        let data = apiService.parseMarkAsFavoriteToData(modelToUpload: favorite)
        apiService.performPostHTTPRequest(data: data, stringURL: endpoint) { [self] data in
            let alert = apiService.parseAlert(data: data)
            print(alert)
            completion()
        }
    }

    func addMovieToFavoriteUsersDefaults(addToWatchList: Bool, addToList: Bool, movie: Movie) {
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

    func checkIfMovieIsInFavorites(checkWatchList: Bool, movie: Movie) -> Bool {
        var objectInArray = true
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

    func createEndpoint(endpoint: String) -> String {
        let sessionID = UserDefaults.standard.string(forKey: "sessionID")
        let accountID = UserDefaults.standard.string(forKey: "accountID")
        let endpoint = endpoint + "&session_id=\(sessionID!)"
        let endpointWithAccountID = endpoint.replacingOccurrences(of: "{account_id}", with: accountID!)
        return endpointWithAccountID
    }

    func checkIfSessionIDExists() -> Bool {
        if UserDefaults.standard.string(forKey: "sessionID") != nil {
            return true
        } else {
            return false
        }
    }
}
