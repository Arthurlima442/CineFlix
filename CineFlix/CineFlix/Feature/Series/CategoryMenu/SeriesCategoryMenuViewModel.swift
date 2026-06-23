//
//  SeriesCategoryMenuViewModel.swift
//  CineFlix
//
//  Created by Arthur Lima on 23/06/2026.
//

import Foundation

protocol SeriesCategoryMenuViewModelProtocol: AnyObject {
    func startLoading()
    func stopLoading()
    func successCategory()
    func failure(message: String)
}

class SeriesCategoryMenuViewModel {
    
    weak var delegate: SeriesCategoryMenuViewModelProtocol?
    private(set) var isError: Bool = false
    var genre: SeriesGenre
    
    init(genre: SeriesGenre) {
        self.genre = genre
    }
    
    private lazy var genreItems: [SeriesGenreItem] =
    SeriesGenre.allCases.map {
        SeriesGenreItem(genre: $0, isSelected: $0 == genre)
    }
    
    func numberOfGenre() -> Int {
        return genreItems.count
    }
    
    func loadCurrentGenre(at index: Int) -> SeriesGenreItem {
        return genreItems[index]
    }
}
