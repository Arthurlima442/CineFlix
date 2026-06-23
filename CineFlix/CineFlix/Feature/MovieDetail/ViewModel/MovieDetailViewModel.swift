//
//  MovieDetailViewModel.swift
//  CineFlix
//
//  Created by Arthur Lima on 07/07/2025.
//
import Foundation

protocol MovieDetailViewModelProtocol: AnyObject {
    func success()
    func failure()
    func startLoading()
    func stopLoading()
}

class MovieDetailViewModel {
    
    private let idMovie: Int
    private var service: MovieDetailService = MovieDetailService()
    private(set) var movieDetail: MovieDetail?
    weak var delegate: MovieDetailViewModelProtocol?
    
    init(idMovie: Int) {
        self.idMovie = idMovie
    }
    
    var numberOfRowsInSection: Int {
        return 2
    }
    
    var getMovieDetail: MovieDetail? {
        return movieDetail
    }
    // Logica para LOADING!!!
    // Colocar o start antes de fazer a request
    // Colocar o stop DENTRO da chave do result, na ultima linha dele antes do fechamento de sua chave
    func fetchDetail() {
        delegate?.startLoading()
        service.fetchMovieDetail(by: idMovie) { result in
            switch result {
            case .success(let success):
                self.movieDetail = success
                self.delegate?.success()
            case .failure:
                self.delegate?.failure()
            }
            self.delegate?.stopLoading()
        }
    }
}
