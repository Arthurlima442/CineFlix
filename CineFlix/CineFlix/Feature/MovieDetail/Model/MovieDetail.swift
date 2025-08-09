//
//  MovieDetail.swift
//  Movie
//
//  Created by Caio Fabrini on 26/07/2025.
//

import Foundation

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let homepage: String?
    let releaseDate: String
    let runtime: Int?
    let voteAverage: Double
    let voteCount: Int
    let adult: Bool
    let genres: [Genre]
    let productionCompanies: [ProductionCompany]
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, homepage, runtime
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genres
        case adult
        case productionCompanies = "production_companies"
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct ProductionCompany: Codable {
    let id: Int
    let name: String
    let logoPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
    }
}
