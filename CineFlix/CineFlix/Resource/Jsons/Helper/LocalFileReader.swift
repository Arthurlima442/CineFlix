//
//  LocalFileReader.swift
//  CineFlix
//
//  Created by Arthur Lima on 20/07/2025.
//

import Foundation

class LocalFileReader {
  static func loadJSON<T: Codable>(fileName: String, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {

      guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        DispatchQueue.main.async {
          completion(.failure(.invalidURL(url: "\(fileName).json")))
        }
        return
      }

      do {
        let data = try Data(contentsOf: url)
        let decodeObject = try JSONDecoder().decode(T.self, from: data)

        DispatchQueue.main.async {
          completion(.success(decodeObject))
        }
      } catch {
        DispatchQueue.main.async {
          completion(.failure(.decodingError(error)))
        }
      }
    }
  }
}
