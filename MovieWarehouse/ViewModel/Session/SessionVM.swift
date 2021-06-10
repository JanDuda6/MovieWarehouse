//
//  SessionListsVM.swift
//  MovieWarehouse
//
//  Created by Kurs on 27/05/2021.
//

import Foundation
import UIKit

class SessionVM {
    private var apiService: APIService
    private var requestToken = ""
    private var sessionID = ""
    private var authEndpoint = ""

    init(apiService: APIService = APIService()) {
        self.apiService = apiService
        createRequestToken()
    }

   private func createRequestToken() {
        apiService.performGetHTTPRequest(request: [GetEndpoints.getSessionRequestToken]) { [self] data, _, _ in
            self.requestToken = apiService.parseRequestToken(data: data).requestToken
            self.authEndpoint = PostEndpoints.authenticateToken.replacingOccurrences(of: "{REQUEST_TOKEN}", with: requestToken)
        }
    }

    func getAuthEndpoint() -> String {
        return authEndpoint
    }

    func getSessionID() {
        let requestToken = RequestToken(requestToken: self.requestToken)
        let data = apiService.parseRequestTokenToData(modelToUpload: requestToken)
        apiService.performPostHTTPRequest(data: data, stringURL: PostEndpoints.getSessionID) { [self] data in
            guard let sessionID = apiService.parseSession(data: data)?.sessionID else {return}
            UserDefaults.standard.set(sessionID, forKey: "sessionID")
            let accountDetailsEndpoint = GetEndpoints.getAccountDetails + "&session_id=\(sessionID)"
            apiService.performGetHTTPRequest(request: [accountDetailsEndpoint]) { data, _, _ in
                let accountDetails = apiService.parseAccountDetails(data: data)
                UserDefaults.standard.set(accountDetails?.id, forKey: "accountID")
            }
        }
    }

    func checkIfSessionIDExists() -> Bool {
        if UserDefaults.standard.string(forKey: "sessionID") != nil {
            return true
        } else {
            return false
        }
    }
}
