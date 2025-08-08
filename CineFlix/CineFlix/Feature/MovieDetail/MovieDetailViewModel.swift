//
//  MovieDetailViewModel.swift
//  CineFlix
//
//  Created by Arthur Lima on 07/07/2025.
//
import Foundation

// Regras da viewModel
// Sua viewModel SEMPRE VAI TER O SEU OBJETO SENDO PRIVATE!!!
// Sempre você terá que criar uma variavel computada(se for um unico item se for uma lista terá que ser uma funçao)
// Se for um unico objeto utilize variavel computada
// var getMovie: Movie {
//    return movie
// }
// Se for uma lista utilize a funcao
// func loudCurrentMovie(indexPath: IndexPath) -> AllMovie {
//    return movieList[indexPath.row]
// }

class MovieDetailViewModel {
    
    private let movie: DetailMovie
    
    init(movie: DetailMovie) {
        self.movie = movie
    }
    
    var numberOfRowsInSection: Int {
        return 2
    }
    
    var getMovie: DetailMovie {
        return movie
    }
}
