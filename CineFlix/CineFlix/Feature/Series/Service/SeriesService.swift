// filepath: SeriesService.swift
//
//  SeriesService.swift
//  CineFlix
//
//  Created by Arthur Lima on 10/01/2025.
//

import Foundation

class SeriesService {

  private let apiKey = "d88b4facc52e394846c3f340cfd88685"

  /// Busca séries populares com suporte a paginação
  /// - Parameters:
  ///   - page: Número da página (padrão: 1)
  ///   - completion: Closure com resultado contendo lista de séries e metadados
  func fetchPopularSeries(page: Int = 1, completion: @escaping (Result<SeriesList, Error>) -> Void) {
    let urlString = "https://api.themoviedb.org/3/tv/popular?api_key=\(apiKey)&language=pt-BR&page=\(page)"
    
    NetworkService.request(urlString: urlString) { (result: Result<SeriesList, Error>) in
      switch result {
      case .success(let seriesList):
        completion(.success(seriesList))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  /// Busca séries mais bem avaliadas com suporte a paginação
  /// - Parameters:
  ///   - page: Número da página (padrão: 1)
  ///   - completion: Closure com resultado contendo lista de séries e metadados
  func fetchTopRatedSeries(page: Int = 1, completion: @escaping (Result<SeriesList, Error>) -> Void) {
    let urlString = "https://api.themoviedb.org/3/tv/top_rated?api_key=\(apiKey)&language=pt-BR&page=\(page)"
    
    NetworkService.request(urlString: urlString) { (result: Result<SeriesList, Error>) in
      switch result {
      case .success(let seriesList):
        completion(.success(seriesList))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  /// Busca séries que estão no ar com suporte a paginação
  /// - Parameters:
  ///   - page: Número da página (padrão: 1)
  ///   - completion: Closure com resultado contendo lista de séries e metadados
  func fetchOnTheAirSeries(page: Int = 1, completion: @escaping (Result<SeriesList, Error>) -> Void) {
    let urlString = "https://api.themoviedb.org/3/tv/on_the_air?api_key=\(apiKey)&language=pt-BR&page=\(page)"
    
    NetworkService.request(urlString: urlString) { (result: Result<SeriesList, Error>) in
      switch result {
      case .success(let seriesList):
        completion(.success(seriesList))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  /// Busca séries por gênero com suporte a paginação
  /// - Parameters:
  ///   - genre: Gênero de série
  ///   - page: Número da página (padrão: 1)
  ///   - completion: Closure com resultado contendo lista de séries e metadados
  func fetchSeriesByGenre(_ genre: SeriesGenre, page: Int = 1, completion: @escaping (Result<SeriesList, Error>) -> Void) {
    let urlString = "https://api.themoviedb.org/3/discover/tv?api_key=\(apiKey)&language=pt-BR&page=\(page)&with_genres=\(genre.rawValue)"
    
    NetworkService.request(urlString: urlString) { (result: Result<SeriesList, Error>) in
      switch result {
      case .success(let seriesList):
        completion(.success(seriesList))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  /// Busca séries por query de pesquisa com suporte a paginação
  /// - Parameters:
  ///   - query: Texto de busca
  ///   - page: Número da página (padrão: 1)
  ///   - completion: Closure com resultado contendo lista de séries e metadados
  func searchSeries(query: String, page: Int = 1, completion: @escaping (Result<SeriesList, Error>) -> Void) {
    guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      completion(.failure(NetworkError.invalidURL))
      return
    }

    let urlString = "https://api.themoviedb.org/3/search/tv?api_key=\(apiKey)&language=pt-BR&page=\(page)&query=\(encodedQuery)"
    
    NetworkService.request(urlString: urlString) { (result: Result<SeriesList, Error>) in
      switch result {
      case .success(let seriesList):
        completion(.success(seriesList))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  /// Busca detalhes completos de uma série
  /// - Parameters:
  ///   - id: ID da série
  ///   - completion: Closure com resultado contendo detalhes da série
  func fetchSeriesDetail(by id: Int, completion: @escaping (Result<SeriesDetail, Error>) -> Void) {
    let urlString = "https://api.themoviedb.org/3/tv/\(id)?api_key=\(apiKey)&language=pt-BR&append_to_response=videos,watch/providers"
    
    NetworkService.request(urlString: urlString) { (result: Result<SeriesDetail, Error>) in
      switch result {
      case .success(let seriesDetail):
        completion(.success(seriesDetail))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
