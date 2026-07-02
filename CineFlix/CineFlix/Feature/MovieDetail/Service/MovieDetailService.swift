//
//  MovieDetailService.swift
//  Movie
//
//  Created by Caio Fabrini on 26/07/2025.
//

import Foundation

class MovieDetailService {
    
    private let apiKey = "d88b4facc52e394846c3f340cfd88685"
    
    func fetchMovieDetail(by id: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)&language=pt-BR&append_to_response=videos"
        
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
