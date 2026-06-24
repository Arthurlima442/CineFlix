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
    func updateSection(at index: Int)  // ← NOVO: atualizar apenas uma seção
}

class HomeViewModel {
    
    weak var delegate: HomeViewModelProtocol?
    private let service: HomeService = HomeService()
    
    // MARK: - Múltiplas Seções
    private(set) var sections: [MovieSection] = []
    private(set) var isError: Bool = false
    private var isLoadingAllSections: Bool = false
    
    // MARK: - Busca
    private var searchQuery: String = ""
    private var isSearching: Bool = false
    var searchResults: [MovieSummary] = []
    
    // MARK: - Setup Inicial
    
    /// Inicializa todas as 23 seções (4 principais + 19 gêneros)
    func setupInitialSections() {
        sections = []
        
        // 4 Seções principais
        sections.append(MovieSection(title: "Filmes Populares", type: .popular))
        sections.append(MovieSection(title: "Mais Bem Avaliados", type: .topRated))
        sections.append(MovieSection(title: "Em Cartaz", type: .nowPlaying))
        sections.append(MovieSection(title: "Lançamentos", type: .upcoming))
        
        // 19 Gêneros
        for genre in MovieGenre.allCases where genre != .all {
            sections.append(MovieSection(title: genre.rawValue, type: .genre(genre), genre: genre))
        }
    }
    
    // MARK: - Carregamento
    
    /// Carrega apenas as 4 seções principais (performance optimization)
    /// As demais seções (gêneros) são carregadas sob demanda
    func loadMainSectionsOnly() {
        // Carrega apenas as 4 seções principais
        let mainSectionIndices = [0, 1, 2, 3]
        loadSelectedSections(mainSectionIndices)
    }
    
    /// Carrega um conjunto específico de seções
    private func loadSelectedSections(_ indices: [Int]) {
        guard !isLoadingAllSections else { return }
        
        isLoadingAllSections = true
        delegate?.startLoading()
        
        var loadedCount = 0
        let totalSections = indices.count
        
        for index in indices {
            loadSectionData(at: index) { [weak self] in
                loadedCount += 1
                
                if loadedCount == totalSections {
                    self?.isLoadingAllSections = false
                    DispatchQueue.main.async {
                        self?.delegate?.stopLoading()
                        self?.delegate?.success()
                    }
                }
            }
        }
    }

    /// Carrega dados para todas as seções (lazy loading)
    func loadAllSections() {
        guard !isLoadingAllSections else { return }
        
        isLoadingAllSections = true
        delegate?.startLoading()
        
        var loadedCount = 0
        let totalSections = sections.count
        
        for (index, _) in sections.enumerated() {
            loadSectionData(at: index) { [weak self] in
                loadedCount += 1
                
                if loadedCount == totalSections {
                    self?.isLoadingAllSections = false
                    DispatchQueue.main.async {
                        self?.delegate?.stopLoading()
                        self?.delegate?.success()
                    }
                }
            }
        }
    }
    
    /// Carrega dados de uma seção específica
    private func loadSectionData(at index: Int, completion: @escaping () -> Void = {}) {
        guard index >= 0, index < sections.count else { completion(); return }
        
        let section = sections[index]
        
        let endpoint = {
            switch section.type {
            case .popular:
                self.service.fetchPopularMovies(page: section.currentPage) { result in
                    self.handleSectionResult(result, at: index)
                    completion()
                }
            case .topRated:
                self.service.fetchTopRatedMovies(page: section.currentPage) { result in
                    self.handleSectionResult(result, at: index)
                    completion()
                }
            case .nowPlaying:
                self.service.fetchNowPlayingMovies(page: section.currentPage) { result in
                    self.handleSectionResult(result, at: index)
                    completion()
                }
            case .upcoming:
                self.service.fetchUpcomingMovies(page: section.currentPage) { result in
                    self.handleSectionResult(result, at: index)
                    completion()
                }
            case .genre:
                if let genre = section.genre {
                    self.service.fetchMoviesByGenre(genre, page: section.currentPage) { result in
                        self.handleSectionResult(result, at: index)
                        completion()
                    }
                } else {
                    completion()
                }
            }
        }
        
        endpoint()
    }
    
    /// Processa resultado de uma seção
    private func handleSectionResult(_ result: Result<MovieList, Error>, at index: Int) {
        switch result {
        case .success(let movieList):
            var section = sections[index]
            section.movies = movieList.results ?? []
            section.totalPages = movieList.totalPages ?? 1
            section.error = nil
            sections[index] = section
            
        case .failure(let error):
            var section = sections[index]
            section.error = error
            sections[index] = section
        }
        
        // Notificar atualização apenas dessa seção
        DispatchQueue.main.async {
            self.delegate?.updateSection(at: index)
        }
    }
    
    // MARK: - Paginação
    
    /// Carrega próxima página de uma seção
    func loadMoreForSection(at index: Int) {
        guard index >= 0, index < sections.count else { return }
        
        var section = sections[index]
        
        // Não carregar se já está carregando ou não há mais páginas
        guard !section.isLoadingMore, section.currentPage < section.totalPages else { return }
        
        section.isLoadingMore = true
        sections[index] = section
        
        section.currentPage += 1
        
        let endpoint = {
            switch section.type {
            case .popular:
                self.service.fetchPopularMovies(page: section.currentPage) { result in
                    self.handleMoreResult(result, at: index)
                }
            case .topRated:
                self.service.fetchTopRatedMovies(page: section.currentPage) { result in
                    self.handleMoreResult(result, at: index)
                }
            case .nowPlaying:
                self.service.fetchNowPlayingMovies(page: section.currentPage) { result in
                    self.handleMoreResult(result, at: index)
                }
            case .upcoming:
                self.service.fetchUpcomingMovies(page: section.currentPage) { result in
                    self.handleMoreResult(result, at: index)
                }
            case .genre:
                if let genre = section.genre {
                    self.service.fetchMoviesByGenre(genre, page: section.currentPage) { result in
                        self.handleMoreResult(result, at: index)
                    }
                }
            }
        }
        
        endpoint()
    }
    
    /// Processa resultado de carregamento de próxima página
    private func handleMoreResult(_ result: Result<MovieList, Error>, at index: Int) {
        guard index >= 0, index < sections.count else { return }
        
        var section = sections[index]
        
        switch result {
        case .success(let movieList):
            section.movies.append(contentsOf: movieList.results ?? [])
            section.totalPages = movieList.totalPages ?? 1
            section.error = nil
            
        case .failure(let error):
            section.currentPage -= 1
            section.error = error
        }
        
        section.isLoadingMore = false
        sections[index] = section
        
        DispatchQueue.main.async {
            self.delegate?.updateSection(at: index)
        }
    }
    
    // MARK: - Filtro por Gênero
    
    /// Filtra para exibir apenas um gênero
    func filterByGenre(_ genre: MovieGenre) {
        // Mantém apenas as 4 seções principais + 1 gênero selecionado
        let mainSections = sections.filter { section in
            switch section.type {
            case .popular, .topRated, .nowPlaying, .upcoming:
                return true
            default:
                return false
            }
        }
        let genreSection = MovieSection(title: genre.rawValue, type: .genre(genre), genre: genre)
        
        sections = mainSections + [genreSection]
        
        // Carrega dados da nova seção de gênero
        loadSectionData(at: sections.count - 1)
    }
    
    /// Volta para exibir todas as 23 seções
    func resetToAllCategories() {
        setupInitialSections()
        loadAllSections()
    }
    
    /// Carrega uma seção sob demanda (lazy loading para gêneros)
    /// Só carrega se ainda não foi carregada
    func loadSectionIfNeeded(at index: Int) {
        guard index >= 0, index < sections.count else { return }
        
        let section = sections[index]
        
        // Só carrega se seção está vazia e não é das 4 principais
        if section.movies.isEmpty && index >= 4 {
            loadSectionData(at: index)
        }
    }
    
    // MARK: - Busca
    
    /// Busca filmes
    func searchMovies(query: String) {
        if query.isEmpty {
            isSearching = false
            searchQuery = ""
            searchResults = []
            delegate?.success()
        } else {
            isSearching = true
            searchQuery = query
            delegate?.startLoading()
            
            service.searchMovies(query: query, page: 1) { result in
                switch result {
                case .success(let movieList):
                    self.searchResults = movieList.results ?? []
                    self.delegate?.success()
                case .failure(let error):
                    print("❌ Error searching movies: \(error.localizedDescription)")
                    self.searchResults = []
                    self.delegate?.failure()
                }
                self.delegate?.stopLoading()
            }
        }
    }
    
    // MARK: - Data Access
    
    func numberOfSections() -> Int {
        return isSearching ? 1 : sections.count
    }
    
    func numberOfMoviesInSection(_ section: Int) -> Int {
        if isSearching {
            return searchResults.isEmpty ? 1 : searchResults.count
        } else {
            guard section >= 0, section < sections.count else { return 1 }
            return sections[section].movies.isEmpty ? 1 : sections[section].movies.count
        }
    }
    
    func getSection(at index: Int) -> MovieSection? {
        guard index >= 0, index < sections.count else { return nil }
        return sections[index]
    }
    
    func getMovieInSection(_ sectionIndex: Int, row: Int) -> MovieSummary? {
        if isSearching {
            guard row >= 0, row < searchResults.count else { return nil }
            return searchResults[row]
        } else {
            guard sectionIndex >= 0, sectionIndex < sections.count else { return nil }
            guard row >= 0, row < sections[sectionIndex].movies.count else { return nil }
            return sections[sectionIndex].movies[row]
        }
    }
}
