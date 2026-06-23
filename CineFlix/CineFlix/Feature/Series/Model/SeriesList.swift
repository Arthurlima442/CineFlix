// filepath: SeriesList.swift
//
//  SeriesList.swift
//  CineFlix
//
//  Created by Arthur Lima on 10/01/2025.
//

import Foundation

struct SeriesList: Codable {
    let page: Int
    let results: [SeriesSummary]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
