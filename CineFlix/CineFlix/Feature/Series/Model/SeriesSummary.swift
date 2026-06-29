// filepath: SeriesSummary.swift
//
//  SeriesSummary.swift
//  CineFlix
//
//  Created by Arthur Lima on 10/01/2025.
//

import Foundation

struct SeriesSummary: Codable, Equatable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let voteAverage: Double
    let firstAirDate: String
    let genreIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case overview
        case voteAverage = "vote_average"
        case firstAirDate = "first_air_date"
        case genreIds = "genre_ids"
    }
}
