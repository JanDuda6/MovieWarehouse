//
//  Endpoints.swift
//  MovieWarehouse
//
//  Created by Kurs on 22/04/2021.
//

import Foundation

struct Endpoints {

    // movies endpoints
    private static let APIKey = "8e1e8bf8317030f59d29f5d495ea6978"
    static let imagePathURL = "https://image.tmdb.org/t/p/w500"
    static let topRatedMoviesURL = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(APIKey)"
    static let mostPopularMoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=\(APIKey)"
    static let upcomingMoviesURL = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(APIKey)"
    static let nowPlaying = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(APIKey)"
    static let trendingMovies = "https://api.themoviedb.org/3/trending/movie/day?api_key=\(APIKey)"
    static let getRecommendationMovies = "https://api.themoviedb.org/3/movie/{movie_id}/recommendations?api_key=\(APIKey)"

    //people endpoints
    static let popularPersonsURL = "https://api.themoviedb.org/3/person/popular?api_key=\(APIKey)"

    //TV endpoints
    static let topRatedTV = "https://api.themoviedb.org/3/tv/top_rated?api_key=\(APIKey)"
    static let mostPopularTV = "https://api.themoviedb.org/3/tv/popular?api_key=\(APIKey)"
    static let tvOnTheAir = "https://api.themoviedb.org/3/tv/on_the_air?api_key=\(APIKey)"
    static let trendingTV = "https://api.themoviedb.org/3/trending/tv/day?api_key=\(APIKey)"
    static let getRecommendationTVShows = "https://api.themoviedb.org/3/tv/{tv_id}/recommendations?api_key=\(APIKey)"

    //Genre lists endpoints
    static let genreMovieList = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(APIKey)"
    static let genreTVList = "https://api.themoviedb.org/3/genre/tv/list?api_key=\(APIKey)"

    //Credits endpoints
    static let movieCredits = "https://api.themoviedb.org/3/movie/{movie_id}/credits?api_key=\(APIKey)"
    static let TVCredits = "https://api.themoviedb.org/3/tv/{tv_id}/credits?api_key=\(APIKey)"


    //Watch Providers endpoints
    static let watchProvidersMovies = "https://api.themoviedb.org/3/movie/{movie_id}/watch/providers?api_key=\(APIKey)"
    static let watchProvidersTVs = "https://api.themoviedb.org/3/tv/{tv_id}/watch/providers?api_key=\(APIKey)"

}


