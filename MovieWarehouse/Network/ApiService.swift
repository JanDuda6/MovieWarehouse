//
//  ApiClient.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation

class APIService {
    private let decoder = JSONDecoder()

    func performGetHTTPRequest(request: [String], completion: @escaping (Data, String, String) -> Void ) {
        for endpoint in request {
            guard let url = URL(string: endpoint) else { return }
            let urlSession = URLSession.shared
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error with: \(error.localizedDescription)")
                    return
                }
                guard let data = data else { return }
                guard let response = response else { return }
                guard let responseURL = response.url?.absoluteString else { return }
                guard let responseCategory = response.suggestedFilename else { return }
                completion(data, responseURL, responseCategory)

            }
            task.resume()
        }
    }

    func performPostHTTPRequest(data: Data, stringURL: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: stringURL) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = data
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            completion(data)
        }
        task.resume()
    }

    func performDeleteHTTPRequest(url: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "DELETE"
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            completion(data)
        }
        task.resume()
    }
}

//MARK: - Encode
extension APIService {
func parseRatingToData(rating: Rate) -> Data {
        return try! JSONEncoder().encode(rating)
    }

    func parseMarkAsFavoriteToData(modelToUpload: AccountList) -> Data {
        return try! JSONEncoder().encode(modelToUpload)
    }

    func parseRequestTokenToData(modelToUpload: RequestToken) -> Data {
        return try! JSONEncoder().encode(modelToUpload)
    }
}

//MARK: - Decode
extension APIService {
    func parseAccountDetails(data: Data) -> AccountDetails? {
        do {
            return try decoder.decode(AccountDetails.self, from: data)
        } catch {
            return nil
        }
    }

    func parseAlert(data: Data) -> Alert {
        return try! decoder.decode(Alert.self, from: data)
    }

    func parseMovieResponse(data: Data) -> MovieResponse {
        return try! decoder.decode(MovieResponse.self, from: data)
    }

    func parsePersonResponse(data: Data) -> PersonResponse {
        return try! decoder.decode(PersonResponse.self, from: data)
    }

    func parseGenreResponse(data: Data) -> GenreResponse {
        return try! decoder.decode(GenreResponse.self, from: data)
    }

    func parseCastResponse(data: Data) -> CreditsResponse {
        return try! decoder.decode(CreditsResponse.self, from: data)
    }

    func parseWatchProvider(data: Data) -> ProvidersResponse {
        return try! decoder.decode(ProvidersResponse.self, from: data)
    }

    func parsePersonData(data: Data) -> Person {
        return try! decoder.decode(Person.self, from: data)
    }
    
    func parsePersonCastData(data: Data) -> PersonCredits {
        return try! decoder.decode(PersonCredits.self, from: data)
    }

    func parseRequestToken(data: Data) -> RequestToken {
        return try! decoder.decode(RequestToken.self, from: data)
    }

    func parseSession(data: Data) -> Session? {
        do {
            return try decoder.decode(Session.self, from: data)
        } catch {
            return nil
        }
    }
}
