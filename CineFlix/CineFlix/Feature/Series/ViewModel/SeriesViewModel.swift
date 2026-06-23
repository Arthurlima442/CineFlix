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
    private var seriesDataList: [SeriesSummary] = []
    private(set) var isError: Bool = false
    private(set) var seriesGenre: SeriesGenre = .actionAdventure
    
    // MARK: - Paginação
    private(set) var currentPage: Int = 1
    private(set) var totalPages: Int = 1
    private(set) var isLoadingMore: Bool = false
    
    var hasMorePages: Bool {
        return currentPage < totalPages
    }
    
    // MARK: - Ações
    
    func fetchPopularSeries() {
        self.currentPage = 1
        self.seriesGenre = .actionAdventure
        
        delegate?.startLoading()
        service.fetchPopularSeries(page: currentPage) { result in
            switch result {
            case .success(let seriesList):
                self.seriesDataList = seriesList.results
                self.totalPages = seriesList.totalPages
                self.isError = false
                self.delegate?.success()
            case .failure(let failure):
                print("❌ Error fetching popular series: \(failure.localizedDescription)")
                self.isError = true
                self.delegate?.failure()
            }
            self.delegate?.stopLoading()
        }
    }
    
    func fetchGenre(genre: SeriesGenreItem) {
        self.seriesGenre = genre.genre
        self.currentPage = 1
        
        delegate?.startLoading()
        service.fetchSeriesByGenre(genre.genre, page: currentPage) { result in
            switch result {
            case .success(let seriesList):
                self.seriesDataList = seriesList.results
                self.totalPages = seriesList.totalPages
                self.isError = false
                self.delegate?.success()
            case .failure(let failure):
                print("❌ Error fetching series by genre: \(failure.localizedDescription)")
                self.isError = true
                self.delegate?.failure()
            }
            self.delegate?.stopLoading()
        }
    }
    
    /// Carrega a próxima página de séries
    func fetchNextPage() {
        // Não carregar se já está carregando ou se não há mais páginas
        guard !isLoadingMore, hasMorePages else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        // Determina qual método chamar baseado no gênero
        service.fetchSeriesByGenre(seriesGenre, page: currentPage) { result in
            self.handleNextPageResult(result)
        }
    }
    
    /// Manipula o resultado do carregamento da próxima página
    private func handleNextPageResult(_ result: Result<SeriesList, Error>) {
        switch result {
        case .success(let seriesList):
            let newSeries = seriesList.results
            self.seriesDataList.append(contentsOf: newSeries)
            self.totalPages = seriesList.totalPages
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
        } else if seriesDataList.isEmpty {
            return 1
        } else {
            return seriesDataList.count
        }
    }
    
    var isNamesEmpty: Bool {
        return seriesDataList.isEmpty
    }
    
    func loadCurrentSeriesSection(indexPath: IndexPath) -> SeriesSummary {
        return seriesDataList[indexPath.row]
    }
    
    func searchSeries(series: String) {
        if series.isEmpty {
            fetchPopularSeries()
        } else {
            currentPage = 1
            service.searchSeries(query: series, page: currentPage) { result in
                switch result {
                case .success(let seriesList):
                    self.seriesDataList = seriesList.results
                    self.totalPages = seriesList.totalPages
                    self.isError = false
                    self.delegate?.success()
                case .failure(let failure):
                    print("❌ Error searching series: \(failure.localizedDescription)")
                    self.isError = true
                    self.delegate?.failure()
                }
            }
        }
    }
}
