//
//  MovieGenre.swift
//  Movie
//
//  Created by Caio Fabrini on 26/07/2025.
//

import Foundation

enum MovieGenre: String, CaseIterable {
    case all = "Populares"
    case action = "Ação"
    case adventure = "Aventura"
    case animation = "Animação"
    case comedy = "Comédia"
    case crime = "Crime"
    case documentary = "Documentário"
    case drama = "Drama"
    case family = "Família"
    case fantasy = "Fantasia"
    case history = "História"
    case horror = "Terror"
    case music = "Música"
    case mystery = "Mistério"
    case romance = "Romance"
    case scienceFiction = "Ficção Científica"
    case tvMovie = "Filme de TV"
    case thriller = "Suspense"
    case war = "Guerra"
    case western = "Faroeste"
    
    var id: Int {
        switch self {
        case .action: return 28
        case .adventure: return 12
        case .animation: return 16
        case .comedy: return 35
        case .crime: return 80
        case .documentary: return 99
        case .drama: return 18
        case .family: return 10751
        case .fantasy: return 14
        case .history: return 36
        case .horror: return 27
        case .music: return 10402
        case .mystery: return 9648
        case .romance: return 10749
        case .scienceFiction: return 878
        case .tvMovie: return 10770
        case .thriller: return 53
        case .war: return 10752
        case .western: return 37
        case .all: return 0
        }
    }
}
