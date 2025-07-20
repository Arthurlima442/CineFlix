//
//  NetworkError.swift
//  CineFlix
//
//  Created by Arthur Lima on 20/07/2025.
//

import Foundation

enum NetworkError {
  case invalidURL(url: String)
  case invalidResponse
  case decodingError(Error)
  case networkFailure(Error)
  case statusCode(code: Int)
  case noData
}

extension NetworkError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidURL(let url):
      return "URL invalida -> \(url)"
    case .invalidResponse:
      return "Resposta invalida da API"
    case .decodingError(let error):
      return "Decodificação falhou: \(error.localizedDescription)"
    case .networkFailure(let error):
      return "Falha na conexão: \(error.localizedDescription)"
    case .statusCode(code: let code):
      return "Status code inesperado: Código \(code)"
    case .noData:
      return "Não houve retorno da API"
    }
  }
}
