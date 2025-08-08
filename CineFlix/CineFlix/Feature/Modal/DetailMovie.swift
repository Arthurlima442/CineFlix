//
//  Movie.swift
//  CineFlix
//
//  Created by Arthur Lima on 07/07/2025.
//

import Foundation

struct DetailMovie: Codable {
    var movieImage: String
    var title: String
    var ageClassification: Int
    var launch: String
    var duration: String
    var synopsis: String
}
