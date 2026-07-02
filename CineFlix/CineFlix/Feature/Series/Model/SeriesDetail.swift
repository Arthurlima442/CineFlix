// filepath: SeriesDetail.swift
//
//  SeriesDetail.swift
//  CineFlix
//
//  Created by Arthur Lima on 10/01/2025.
//

import Foundation

struct SeriesDetail: Codable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let voteAverage: Double
    let firstAirDate: String
    let lastAirDate: String?
    let genres: [Genre]
    let numberOfSeasons: Int
    let numberOfEpisodes: Int
    let status: String
    let networks: [Network]
    let videos: SeriesVideosResponse?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case overview
        case voteAverage = "vote_average"
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case genres
        case numberOfSeasons = "number_of_seasons"
        case numberOfEpisodes = "number_of_episodes"
        case status
        case networks
        case videos
    }
    
    struct Genre: Codable {
        let id: Int
        let name: String
    }
    
    struct Network: Codable {
        let id: Int
        let name: String
        let logoPath: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case logoPath = "logo_path"
        }
    }
}

struct SeriesVideosResponse: Codable {
    let results: [SeriesVideo]?
}

struct SeriesVideo: Codable {
    let key: String
    let name: String
    let site: String
    let type: String
}
