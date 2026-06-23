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
    
    // MARK: - Paginação
    private(set) var currentPage: Int = 1
    private(set) var totalPages: Int = 1
    private(set) var isLoadingMore: Bool = false
    
    var hasMorePages: Bool {
        return currentPage < totalPages
    }
    
    func fetchPopularMovie() {
        currentPage = 1
        delegate?.startLoading()
        service.fetchPopularMovies(page: currentPage) { result in
            switch result {
            case .success(let movieList):
                self.movieDataList = movieList.results ?? []
                self.totalPages = movieList.totalPages ?? 1
                self.isError = false
                self.delegate?.success()
            case .failure(let failure):
                print("❌ Error fetching popular movies: \(failure.localizedDescription)")
                self.isError = true
                self.delegate?.failure()
            }
            
            self.delegate?.stopLoading()
        }
    }
    
    // MARK: - Ações
    
    func fetchGenre(genre: GenreItem) {
        self.movieGenre = genre.genre
        self.currentPage = 1
        
        if genre.genre == .all {
            fetchPopularMovie()
        } else {
            delegate?.startLoading()
            service.fetchMoviesByGenre(genre.genre, page: currentPage) { result in
                switch result {
                case .success(let movieList):
                    self.movieDataList = movieList.results ?? []
                    self.totalPages = movieList.totalPages ?? 1
                    self.isError = false
                    self.delegate?.success()
                case .failure(let failure):
                    print("❌ Error fetching movies by genre: \(failure.localizedDescription)")
                    self.isError = true
                    self.delegate?.failure()
                }
                self.delegate?.stopLoading()
            }
        }
    }
    
    /// Carrega a próxima página de filmes
    func fetchNextPage() {
        // Não carregar se já está carregando ou se não há mais páginas
        guard !isLoadingMore, hasMorePages else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        // Determina qual método chamar baseado no gênero
        if movieGenre == .all {
            service.fetchPopularMovies(page: currentPage) { result in
                self.handleNextPageResult(result)
            }
        } else {
            service.fetchMoviesByGenre(movieGenre, page: currentPage) { result in
                self.handleNextPageResult(result)
            }
        }
    }
    
    /// Manipula o resultado do carregamento da próxima página
    private func handleNextPageResult(_ result: Result<MovieList, Error>) {
        switch result {
        case .success(let movieList):
            let newMovies = movieList.results ?? []
            self.movieDataList.append(contentsOf: newMovies)
            self.totalPages = movieList.totalPages ?? 1
            self.isError = false
            DispatchQueue.main.async {
                self.delegate?.success()
            }
        case .failure(let failure):
            print("❌ Error fetching next page: \(failure.localizedDescription)")
            self.currentPage -= 1 // Volta à página anterior em caso de erro
            self.isError = true
            DispatchQueue.main.async {
                self.delegate?.failure()
            }
        }
        
        self.isLoadingMore = false
    }
    
    func numberOfNames() -> Int {
        if isError {
            return 1
        } else if movieDataList.isEmpty {
            return 1
        } else {
            return movieDataList.count
        }
    }
    
    var isNamesEmpty: Bool {
        return movieDataList.isEmpty
    }
    
    func loudCurrentMovieSection(indexPath: IndexPath) -> MovieSummary {
        return movieDataList[indexPath.row]
    }
    
    func searchMovie(movie: String) {
        if movie.isEmpty {
            fetchPopularMovie()
        } else {
            currentPage = 1
            service.searchMovies(query: movie, page: currentPage) { result in
                switch result {
                case .success(let movieList):
                    self.movieDataList = movieList.results ?? []
                    self.totalPages = movieList.totalPages ?? 1
                    self.isError = false
                    self.delegate?.success()
                case .failure(let failure):
                    print("❌ Error searching movies: \(failure.localizedDescription)")
                    self.isError = true
                    self.delegate?.failure()
                }
            }
        }
    }
}
