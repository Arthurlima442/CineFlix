//
//  HomeService.swift
//  Movie
//
//  Created by Caio Fabrini on 26/07/2025.
//

import Foundation

class HomeService {

  private let apiKey = "ea1bfb9a0f4886c39967baaab322b1d8"

  /// Busca filmes populares com suporte a paginação
  /// - Parameters:
  ///   - page: Número da página (padrão: 1)
  ///   - completion: Closure com resultado contendo lista de filmes e metadados
  func fetchPopularMovies(page: Int = 1, completion: @escaping (Result<MovieList, Error>) -> Void) {
    let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=pt-BR&page=\(page)"
    
    NetworkService.request(urlString: urlString) { (result: Result<MovieList, Error>) in
      switch result {
      case .success(let movieList):
        completion(.success(movieList))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  /// Busca filmes melhor avaliados com suporte a paginação
  /// - Parameters:
  ///   - page: Número da página (padrão: 1)
  ///   - completion: Closure com resultado contendo lista de filmes e metadados
  func fetchTopRatedMovies(page: Int = 1, completion: @escaping (Result<MovieList, Error>) -> Void) {
    let urlString = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)&language=pt-BR&page=\(page)"
    
    NetworkService.request(urlString: urlString) { (result: Result<MovieList, Error>) in
      switch result {
      case .success(let movieList):
        completion(.success(movieList))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  /// Busca filmes em cartaz com suporte a paginação
  /// - Parameters:
  ///   - page: Número da página (padrão: 1)
  ///   - completion: Closure com resultado contendo lista de filmes e metadados
  func fetchNowPlayingMovies(page: Int = 1, completion: @escaping (Result<MovieList, Error>) -> Void) {
    let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=pt-BR&page=\(page)"
    
    NetworkService.request(urlString: urlString) { (result: Result<MovieList, Error>) in
      switch result {
      case .success(let movieList):
        completion(.success(movieList))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  /// Busca filmes lançamentos futuros com suporte a paginação
  /// - Parameters:
  ///   - page: Número da página (padrão: 1)
  ///   - completion: Closure com resultado contendo lista de filmes e metadados
  func fetchUpcomingMovies(page: Int = 1, completion: @escaping (Result<MovieList, Error>) -> Void) {
    let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&language=pt-BR&page=\(page)"
    
    NetworkService.request(urlString: urlString) { (result: Result<MovieList, Error>) in
      switch result {
      case .success(let movieList):
        completion(.success(movieList))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  /// Busca filmes por gênero com suporte a paginação
  /// - Parameters:
  ///   - genre: Gênero de filme
  ///   - page: Número da página (padrão: 1)
  ///   - completion: Closure com resultado contendo lista de filmes e metadados
  func fetchMoviesByGenre(_ genre: MovieGenre, page: Int = 1, completion: @escaping (Result<MovieList, Error>) -> Void) {
    let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&language=pt-BR&page=\(page)&with_genres=\(genre.id)"
    
    NetworkService.request(urlString: urlString) { (result: Result<MovieList, Error>) in
      switch result {
      case .success(let movieList):
        completion(.success(movieList))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  /// Busca filmes por query de pesquisa com suporte a paginação
  /// - Parameters:
  ///   - query: Texto de busca
  ///   - page: Número da página (padrão: 1)
  ///   - completion: Closure com resultado contendo lista de filmes e metadados
  func searchMovies(query: String, page: Int = 1, completion: @escaping (Result<MovieList, Error>) -> Void) {
    guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      completion(.failure(NetworkError.invalidURL))
      return
    }

    let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=pt-BR&page=\(page)&query=\(encodedQuery)"
    
    NetworkService.request(urlString: urlString) { (result: Result<MovieList, Error>) in
      switch result {
      case .success(let movieList):
        completion(.success(movieList))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
