//
//  NetworkService.swift
//  CineFlix
//
//  Created by Arthur Lima on 23/06/2026.
//

import Foundation

/// Erros possíveis na camada de rede
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case noData
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .invalidResponse:
            return "Resposta inválida"
        case .httpError(let statusCode):
            return "Erro HTTP \(statusCode)"
        case .noData:
            return "Sem dados de resposta"
        case .decodingError(let error):
            return "Erro ao decodificar: \(error.localizedDescription)"
        case .networkError(let error):
            return "Erro de rede: \(error.localizedDescription)"
        }
    }
}

class NetworkService {
    
    private init() {}
    
    /// Faz uma requisição HTTP genérica e decodifica o resultado
    /// - Parameters:
    ///   - urlString: URL da requisição
    ///   - completion: Closure que retorna o resultado tipado ou erro
    static func request<T: Decodable>(
        urlString: String,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let startTime = Date()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                NetworkLogger.log(request: request, response: response, data: data, error: error, startTime: startTime)
                
                // Trata erro de rede
                if let error = error {
                    completion(.failure(NetworkError.networkError(error)))
                    return
                }
                
                // Valida resposta HTTP
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                
                // Valida status code
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkError.httpError(statusCode: httpResponse.statusCode)))
                    return
                }
                
                // Valida dados
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                // Decodifica resposta
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    completion(.failure(NetworkError.decodingError(error)))
                }
            }
        }.resume()
    }
}
