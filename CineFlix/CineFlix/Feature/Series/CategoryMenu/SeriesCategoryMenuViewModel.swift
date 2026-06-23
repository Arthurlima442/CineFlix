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
    
    init() {}
    
    private lazy var genreItems: [SeriesGenreItem] = {
        var items: [SeriesGenreItem] = [
            SeriesGenreItem(title: "Populares", genre: nil, isSelected: false)
        ]
        
        for genre in SeriesGenre.allCases {
            items.append(SeriesGenreItem(title: genre.displayName, genre: genre, isSelected: false))
        }
        
        return items
    }()
    
    func numberOfGenre() -> Int {
        return genreItems.count
    }
    
    func loadCurrentGenre(at index: Int) -> SeriesGenreItem {
        return genreItems[index]
    }
}
