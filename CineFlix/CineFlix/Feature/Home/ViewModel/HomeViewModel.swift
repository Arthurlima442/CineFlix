//
//  HomeViewModel.swift
//  CineFlix
//
//  Created by Arthur Lima on 08/07/2025.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    func success()
    func failure()
    func startLoading()
    func stopLoading()
}

class HomeViewModel {
    
    weak var delegate: HomeViewModelProtocol?
    private let service: HomeService = HomeService()
    private var movieDataList: [MovieSummary] = []
    private(set) var isError: Bool = false
    private(set) var movieGenre: MovieGenre = .all
    
    func fetchPopularMovie() {
        service.fetchPopularMovies { result in
            switch result {
            case .success(let success):
                self.movieDataList = success
                self.isError = false
                self.delegate?.success()
            case .failure(let failure):
                print("deu ruim: \(failure.localizedDescription)")
                self.isError = true
                self.delegate?.failure()
            }
        }
    }
    
    // MARK: - Ações
    
    
    func fetchGenre(genre: GenreItem) {
        self.movieGenre = genre.genre
        if genre.genre == .all {
            fetchPopularMovie()
        } else {
            service.fetchMoviesByGenre(genre.genre) { result in
                switch result {
                case .success(let success):
                    self.movieDataList = success
                    self.isError = false
                    self.delegate?.success()
                case .failure(let failure):
                    print("deu ruim genero: \(failure.localizedDescription)")
                    self.isError = true
                    self.delegate?.failure()
                }
            }
        }
    }
    
    func numberOfNames() -> Int {
        if isError {
            return 1
        } else  if movieDataList.isEmpty {
            return 1
        } else {
            return movieDataList.count
        }
    }
    
    var isNamesEmpty: Bool {
        return movieDataList.isEmpty
    }
    
    //    func isNamesEmpty() -> Bool {
    //        return names.isEmpty
    //    }
    
    func loudCurrentMovieSection(indexPath: IndexPath) -> MovieSummary {
        return movieDataList[indexPath.row]
    }
    
    func searchMovie(movie: String) {
        if movie.isEmpty {
            fetchPopularMovie()
        } else {
            service.searchMovies(query: movie) { result in
                switch result {
                case .success(let success):
                    self.movieDataList = success
                    self.isError = false
                    self.delegate?.success()
                case .failure(let failure):
                    print("deu ruim buscar filme: \(failure.localizedDescription)")
                    self.isError = true
                    self.delegate?.failure()
                }
            }
        }
    }
}
