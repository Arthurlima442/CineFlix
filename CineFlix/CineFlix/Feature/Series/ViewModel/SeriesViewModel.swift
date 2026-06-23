//
//  SeriesViewModel.swift
//  CineFlix
//
//  Created by Arthur Lima on 23/06/2026.
//

import Foundation

protocol SeriesViewModelProtocol: AnyObject {
    func success()
    func failure()
    func startLoading()
    func stopLoading()
}

class SeriesViewModel {
    
    weak var delegate: SeriesViewModelProtocol?
    private let service: SeriesService = SeriesService()
    
    // MARK: - Múltiplas Seções
    private(set) var sections: [SeriesSection] = []
    private(set) var isError: Bool = false
    private var isLoadingAllSections: Bool = false
    
    // MARK: - Busca
    private var searchQuery: String = ""
    private var isSearching: Bool = false
    private var searchResults: [SeriesSummary] = []
    
    // MARK: - Setup Inicial
    
    /// Inicializa todas as 23 seções (3 principais + 20 gêneros)
    func setupInitialSections() {
        sections = []
        
        // 3 Seções principais
        sections.append(SeriesSection(title: "Séries Populares", type: .popular))
        sections.append(SeriesSection(title: "Mais Bem Avaliadas", type: .topRated))
        sections.append(SeriesSection(title: "Em Alta", type: .onTheAir))
        
        // 20 Gêneros
        for genre in SeriesGenre.allCases {
            sections.append(SeriesSection(title: genre.displayName, type: .genre, genre: genre))
        }
    }
    
    // MARK: - Carregamento
    
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
                self.service.fetchPopularSeries(page: section.currentPage) { result in
                    self.handleSectionResult(result, at: index)
                    completion()
                }
            case .topRated:
                self.service.fetchTopRatedSeries(page: section.currentPage) { result in
                    self.handleSectionResult(result, at: index)
                    completion()
                }
            case .onTheAir:
                self.service.fetchOnTheAirSeries(page: section.currentPage) { result in
                    self.handleSectionResult(result, at: index)
                    completion()
                }
            case .genre:
                if let genre = section.genre {
                    self.service.fetchSeriesByGenre(genre, page: section.currentPage) { result in
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
    private func handleSectionResult(_ result: Result<SeriesList, Error>, at index: Int) {
        switch result {
        case .success(let seriesList):
            var section = sections[index]
            section.series = seriesList.results
            section.totalPages = seriesList.totalPages
            section.error = nil
            sections[index] = section
            
        case .failure(let error):
            var section = sections[index]
            section.error = error
            sections[index] = section
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
                self.service.fetchPopularSeries(page: section.currentPage) { result in
                    self.handleMoreResult(result, at: index)
                }
            case .topRated:
                self.service.fetchTopRatedSeries(page: section.currentPage) { result in
                    self.handleMoreResult(result, at: index)
                }
            case .onTheAir:
                self.service.fetchOnTheAirSeries(page: section.currentPage) { result in
                    self.handleMoreResult(result, at: index)
                }
            case .genre:
                if let genre = section.genre {
                    self.service.fetchSeriesByGenre(genre, page: section.currentPage) { result in
                        self.handleMoreResult(result, at: index)
                    }
                }
            }
        }
        
        endpoint()
    }
    
    /// Processa resultado de carregamento de próxima página
    private func handleMoreResult(_ result: Result<SeriesList, Error>, at index: Int) {
        guard index >= 0, index < sections.count else { return }
        
        var section = sections[index]
        
        switch result {
        case .success(let seriesList):
            section.series.append(contentsOf: seriesList.results)
            section.totalPages = seriesList.totalPages
            section.error = nil
            
        case .failure(let error):
            section.currentPage -= 1 // Volta à página anterior em caso de erro
            section.error = error
        }
        
        section.isLoadingMore = false
        sections[index] = section
        
        DispatchQueue.main.async {
            self.delegate?.success()
        }
    }
    
    // MARK: - Filtro por Gênero
    
    /// Filtra para exibir apenas um gênero
    func filterByGenre(_ genre: SeriesGenre) {
        // Mantém apenas as 3 seções principais + 1 gênero selecionado
        let mainSections = sections.filter { $0.type != .genre }
        let genreSection = SeriesSection(title: genre.displayName, type: .genre, genre: genre)
        
        sections = mainSections + [genreSection]
        
        // Carrega dados da nova seção de gênero
        loadSectionData(at: sections.count - 1)
    }
    
    /// Volta para exibir todas as 23 seções
    func resetToAllCategories() {
        setupInitialSections()
        loadAllSections()
    }
    
    // MARK: - Busca
    
    /// Busca séries
    func searchSeries(query: String) {
        if query.isEmpty {
            isSearching = false
            searchQuery = ""
            searchResults = []
            delegate?.success()
        } else {
            isSearching = true
            searchQuery = query
            delegate?.startLoading()
            
            service.searchSeries(query: query, page: 1) { result in
                switch result {
                case .success(let seriesList):
                    self.searchResults = seriesList.results
                    self.delegate?.success()
                case .failure(let error):
                    print("❌ Error searching series: \(error.localizedDescription)")
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
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        if isSearching {
            return searchResults.isEmpty ? 1 : searchResults.count
        } else {
            guard section >= 0, section < sections.count else { return 1 }
            return sections[section].series.isEmpty ? 1 : sections[section].series.count
        }
    }
    
    func getSection(at index: Int) -> SeriesSection? {
        guard index >= 0, index < sections.count else { return nil }
        return sections[index]
    }
    
    func getSeriesInSection(_ sectionIndex: Int, row: Int) -> SeriesSummary? {
        if isSearching {
            guard row >= 0, row < searchResults.count else { return nil }
            return searchResults[row]
        } else {
            guard sectionIndex >= 0, sectionIndex < sections.count else { return nil }
            guard row >= 0, row < sections[sectionIndex].series.count else { return nil }
            return sections[sectionIndex].series[row]
        }
    }
}
