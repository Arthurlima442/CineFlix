// filepath: SeriesGenre.swift
//
//  SeriesGenre.swift
//  CineFlix
//
//  Created by Arthur Lima on 10/01/2025.
//

import Foundation

enum SeriesGenre: Int, CaseIterable {
    case actionAdventure = 10759
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case fantasy = 10765
    case history = 36
    case horror = 27
    case kids = 10762
    case mystery = 9648
    case news = 10763
    case reality = 10764
    case romance = 10749
    case soap = 10766
    case talk = 10767
    case thriller = 53
    case warPolitics = 10768
    case western = 37
    
    var displayName: String {
        switch self {
        case .actionAdventure: return "Ação & Aventura"
        case .animation: return "Animação"
        case .comedy: return "Comédia"
        case .crime: return "Crime"
        case .documentary: return "Documentário"
        case .drama: return "Drama"
        case .family: return "Família"
        case .fantasy: return "Fantasia"
        case .history: return "História"
        case .horror: return "Terror"
        case .kids: return "Infantil"
        case .mystery: return "Mistério"
        case .news: return "Notícias"
        case .reality: return "Reality"
        case .romance: return "Romance"
        case .soap: return "Soap"
        case .talk: return "Talk Show"
        case .thriller: return "Suspense"
        case .warPolitics: return "Guerra & Política"
        case .western: return "Western"
        }
    }
}
