//
//  MovieDetailService.swift
//  Movie
//
//  Created by Caio Fabrini on 26/07/2025.
//

import Foundation

class MovieDetailService {
    
    private let apiKey = "ea1bfb9a0f4886c39967baaab322b1d8"
    
    func fetchMovieDetail(by id: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)&language=pt-BR"
        
        NetworkService.request(urlString: urlString) { (result: Result<MovieDetail, Error>) in
            switch result {
            case .success(let movieDetail):
                completion(.success(movieDetail))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
