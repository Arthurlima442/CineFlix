//
//  Category.swift
//  CineFlix
//
//  Created by Arthur Lima on 08/07/2025.
//
import Foundation

protocol CategoryMenuViewModelProtocol: AnyObject {
    func startLoading()
    func stopLoading()
    func successCategory()
    func failure(message: String)
}

class CategoryMenuViewModel {
    
    weak var delegate: CategoryMenuViewModelProtocol?
    private(set) var isError: Bool = false
    var genre: MovieGenre
    
    init(genre: MovieGenre) {
        self.genre = genre
    }
    
    private lazy var genreItems: [GenreItem] =
    MovieGenre.allCases.map {
        GenreItem(genre: $0, isSelected: $0 == genre)
    }
    
    func numberOfGenre() -> Int {
        return genreItems.count
    }
    
    func loadCurrentGenre(at index: Int) -> GenreItem {
        return genreItems[index]
    }
}
