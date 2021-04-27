//
//  Endpoints.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation

struct Endpoints {
    private static let APIKey = "8e1e8bf8317030f59d29f5d495ea6978"
    static let imagePathURL = "https://image.tmdb.org/t/p/w500"
    static let topRatedMoviesURL = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(APIKey)"
    static let mostPopularMoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=\(APIKey)"
    static let upcomingMoviesURL = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(APIKey)"
    static let popularPersonsURL = "https://api.themoviedb.org/3/person/popular?api_key=\(APIKey)"
    static let nowPlaying = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(APIKey)"
}


