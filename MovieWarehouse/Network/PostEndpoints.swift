//
//  PostEndpoints.swift
//  MovieWarehouse
//
//  Created by Kurs on 27/05/2021.
//

import Foundation

struct PostEndpoints {
    private static let APIKey = "8e1e8bf8317030f59d29f5d495ea6978"
    static let getSessionID = "https://api.themoviedb.org/3/authentication/session/new?api_key=\(APIKey)"
    static let authenticateToken = "https://www.themoviedb.org/authenticate/{REQUEST_TOKEN}?redirect_to=moviewarehouse://"
    static let postMarkAsFavorite = "https://api.themoviedb.org/3/account/{account_id}/favorite?api_key=\(APIKey)"
    static let postWatchList = "https://api.themoviedb.org/3/account/{account_id}/watchlist?api_key=\(APIKey)"
    static let postRatedMovies = "https://api.themoviedb.org/3/{movie}/{movie_id}/rating?api_key=\(APIKey)"
}
