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
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URL inválida", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let startTime = Date()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                NetworkLogger.log(request: request, response: response, data: data, error: error, startTime: startTime)
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "Resposta inválida", code: 0)))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    let statusError = NSError(domain: "Erro HTTP",
                                              code: httpResponse.statusCode,
                                              userInfo: [NSLocalizedDescriptionKey: "Erro HTTP \(httpResponse.statusCode)"])
                    completion(.failure(statusError))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "Sem dados de resposta", code: 0)))
                    return
                }
                
                do {
                    let object = try JSONDecoder().decode(MovieDetail.self, from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
