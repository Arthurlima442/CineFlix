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
    func updateSection(at index: Int)
}

class HomeViewModel {
    
    weak var delegate: HomeViewModelProtocol?
    private let service: HomeService = HomeService()
    
    // MARK: - Múltiplas Seções
    private(set) var sections: [MovieSection] = []
    private(set) var isError: Bool = false
    private var isLoadingAllSections: Bool = false
    
    // MARK: - Section Loading Control (Eager Loading Protection)
    private var sectionLoadingStatus: [Int: Bool] = [:]
    private var preloadQueue: DispatchQueue = DispatchQueue(label: "com.cineflix.preload.home", qos: .background)
    private var isPreloadingGenres: Bool = false
    
    // MARK: - Busca
    private(set) var searchQuery: String = ""
    private(set) var isSearching: Bool = false
    private(set) var searchResults: [MovieSummary] = []
    
    // MARK: - Setup Inicial
    
    /// Inicializa todas as 4 seções principais + gêneros
    func setupInitialSections() {
        sections = []
        sections.append(MovieSection(title: "Filmes Populares", type: .popular))
        sections.append(MovieSection(title: "Mais Bem Avaliados", type: .topRated))
        sections.append(MovieSection(title: "Em Breve", type: .upcoming))
        sections.append(MovieSection(title: "Tendência Agora", type: .nowPlaying))
        
        // Adiciona seções de gêneros
        for genre in MovieGenre.allCases {
            sections.append(MovieSection(title: genre.displayName, type: .genre, genre: genre))
        }
    }
    
    // MARK: - Carregamento
    
    /// Carrega apenas as 4 seções principais (não os gêneros)
    func loadMainSectionsOnly() {
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
            case .upcoming:
                self.service.fetchUpcomingMovies(page: section.currentPage) { result in
                    self.handleSectionResult(result, at: index)
                    completion()
                }
            case .nowPlaying:
                self.service.fetchNowPlayingMovies(page: section.currentPage) { result in
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
        
        DispatchQueue.main.async {
            self.delegate?.updateSection(at: index)
        }
    }
    
    // MARK: - Paginação
    
    /// Carrega próxima página de uma seção
    func loadMoreForSection(at index: Int) {
        guard index >= 0, index < sections.count else { return }
        
        var section = sections[index]
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
            case .upcoming:
                self.service.fetchUpcomingMovies(page: section.currentPage) { result in
                    self.handleMoreResult(result, at: index)
                }
            case .nowPlaying:
                self.service.fetchNowPlayingMovies(page: section.currentPage) { result in
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
        let mainSections = sections.filter { $0.type != .genre }
        let genreSection = MovieSection(title: genre.displayName, type: .genre, genre: genre)
        
        sections = mainSections + [genreSection]
        loadSectionData(at: sections.count - 1)
    }
    
    /// Volta para exibir todas as seções
    func resetToAllCategories() {
        setupInitialSections()
        loadMainSectionsOnly()
    }
    
    /// Carrega uma seção sob demanda com proteção contra duplicação
    func loadSectionIfNeeded(at index: Int, force: Bool = false) {
        guard index >= 0, index < sections.count else { return }
        
        let section = sections[index]
        
        // Proteção: não carregar se já está carregando
        if isLoadingSection(at: index) && !force {
            return
        }
        
        // Não carregar se já tem dados (a menos que force)
        if !section.movies.isEmpty && !force {
            return
        }
        
        // Marca como carregando
        setLoadingSection(true, at: index)
        
        // Dispara carregamento
        loadSectionData(at: index) { [weak self] in
            self?.setLoadingSection(false, at: index)
        }
    }
    
    // MARK: - Section Loading Control Helpers
    
    /// Verifica se uma seção está carregando
    private func isLoadingSection(at index: Int) -> Bool {
        return sectionLoadingStatus[index] ?? false
    }
    
    /// Marca seção como carregando/não carregando
    private func setLoadingSection(_ loading: Bool, at index: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.sectionLoadingStatus[index] = loading
        }
    }
    
    /// Precarrega todos os gêneros em sequência (após 4 principais)
    func preloadAllGenres() {
        guard !isPreloadingGenres else { return }
        
        isPreloadingGenres = true
        
        // Encontra índice inicial dos gêneros (após 4 principais)
        let genreStartIndex = 4
        let totalSections = sections.count
        
        preloadQueue.async { [weak self] in
            for index in genreStartIndex..<totalSections {
                // Aguarda 200ms antes de cada requisição (fila sequencial)
                usleep(200_000)
                
                DispatchQueue.main.async {
                    self?.loadSectionIfNeeded(at: index, force: true)
                }
            }
            
            DispatchQueue.main.async {
                self?.isPreloadingGenres = false
            }
        }
    }
    
    // MARK: - Busca
    
    /// Busca filmes
    func searchMovies(query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespaces)
        if trimmedQuery.isEmpty {
            DispatchQueue.main.async {
                self.isSearching = false
                self.searchQuery = ""
                self.searchResults = []
                self.delegate?.stopLoading()
                self.delegate?.success()
            }
        } else {
            DispatchQueue.main.async {
                self.isSearching = true
                self.searchQuery = trimmedQuery
                self.delegate?.startLoading()
            }
            
            service.searchMovies(query: trimmedQuery, page: 1) { result in
                DispatchQueue.main.async {
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
    }
    
    /// Limpa o estado de busca
    func clearSearch() {
        isSearching = false
        searchQuery = ""
        searchResults = []
        delegate?.success()
    }
    
    // MARK: - Data Access
    
    func numberOfSections() -> Int {
        return isSearching ? 1 : sections.count
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
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
