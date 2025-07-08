//
//  HomeViewModel.swift
//  CineFlix
//
//  Created by Arthur Lima on 08/07/2025.
//

import Foundation

class HomeViewModel {
    private var sections: [MovieSection] = [
        MovieSection(title: "Recently Released", movieList: [
            Movie(
                movieImage: "coverSuperman",
                title: "Superman Returns",
                ageClassification: 12,
                launch: "2023",
                duration: "2h 10m",
                synopsis: "Superman faces a new threat while reconnecting with Lois Lane."
            ),
            Movie(
                movieImage: "coverDragao",
                title: "Dragon Awakens",
                ageClassification: 14,
                launch: "2023",
                duration: "1h 55m",
                synopsis: "A warrior bonds with a mythical dragon to save her kingdom."
            ),
            Movie(
                movieImage: "coverPecadores",
                title: "The Sinners",
                ageClassification: 16,
                launch: "2023",
                duration: "2h 00m",
                synopsis: "A group of friends hide dark secrets with dangerous consequences."
            )
        ]),
        
        MovieSection(title: "Also in Theaters", movieList: [
            Movie(
                movieImage: "coverF1",
                title: "Formula Speed",
                ageClassification: 10,
                launch: "2023",
                duration: "1h 45m",
                synopsis: "A rookie driver enters the high-stakes world of Formula One."
            ),
            Movie(
                movieImage: "carros",
                title: "Cars Recharged",
                ageClassification: 0,
                launch: "2023",
                duration: "1h 40m",
                synopsis: "Lightning McQueen returns for one last race to inspire a new generation."
            ),
            Movie(
                movieImage: "coverlilo",
                title: "Lilo's Legacy",
                ageClassification: 6,
                launch: "2023",
                duration: "1h 35m",
                synopsis: "Lilo and Stitch face a new alien invasion in Hawaii."
            )
        ]),
        
        MovieSection(title: "Recommended for You", movieList: [
            Movie(
                movieImage: "coverterraMafia",
                title: "Mafia Land",
                ageClassification: 18,
                launch: "2023",
                duration: "2h 15m",
                synopsis: "A young man rises through the mafia ranks in Naples."
            ),
            Movie(
                movieImage: "jurrasic",
                title: "Jurassic World: Dominion",
                ageClassification: 12,
                launch: "2022",
                duration: "2h 27m",
                synopsis: "Humans and dinosaurs coexist in a fragile new world."
            ),
            Movie(
                movieImage: "carros",
                title: "Cars Recharged",
                ageClassification: 0,
                launch: "2023",
                duration: "1h 40m",
                synopsis: "Lightning McQueen returns for one last race to inspire a new generation."
            )
        ])
    ]
    
    var numberOfRowsInSection: Int {
        return sections.count
    }
    
    func loudCurrentMovieSection(indexPath: IndexPath) -> MovieSection {
        return sections[indexPath.row]
    }
}
