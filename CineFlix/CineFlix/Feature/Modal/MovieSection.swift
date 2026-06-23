//
//  MovieSection.swift
//  CineFlix
//
//  Created by Arthur Lima on 23/06/2026.
//

import Foundation

enum MovieSectionType {
    case popular
    case topRated
    case nowPlaying
    case upcoming
    case genre(MovieGenre)
}

struct MovieSection {
    var title: String
    var type: MovieSectionType
    var genre: MovieGenre?
    var movies: [MovieSummary] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var isLoadingMore: Bool = false
    var error: Error?
}
