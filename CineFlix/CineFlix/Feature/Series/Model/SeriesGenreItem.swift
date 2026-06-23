//
//  SeriesGenreItem.swift
//  CineFlix
//
//  Created by Arthur Lima on 23/06/2026.
//

import Foundation

struct SeriesGenreItem: Hashable {
    let title: String
    let genre: SeriesGenre?
    var isSelected: Bool = false
}
