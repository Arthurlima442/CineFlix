//
//  MovieSection.swift
//  CineFlix
//
//  Created by Arthur Lima on 23/06/2026.
//

import Foundation

// MARK: - MovieSection

struct MovieSection {
    enum SectionType {
        case popular
        case topRated
        case nowPlaying
        case upcoming
        case genre
    }
    
    let title: String
    let type: SectionType
    let genre: MovieGenre?
    
    var movies: [MovieSummary] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var isLoadingMore: Bool = false
    var error: Error?
    
    init(title: String, type: SectionType, genre: MovieGenre? = nil) {
        self.title = title
        self.type = type
        self.genre = genre
    }
}
