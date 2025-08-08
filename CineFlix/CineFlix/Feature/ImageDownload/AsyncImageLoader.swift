//
//  AsyncImageLoader.swift
//  Movie
//
//  Created by Arthur Lima on 02/08/2025.
//

import UIKit

extension UIImageView {

    /// Carrega uma imagem de forma assíncrona a partir de uma URL, com suporte a placeholder, imagem de erro e cache.
    func loadImageFromURL(from url: URL,
                   placeholder: UIImage? = nil,
                   errorImage: UIImage? = nil,
                   completionHandler: ((Result<UIImage, ImageLoadingError>) -> Void)? = nil) {
        // Define a imagem placeholder inicialmente
        self.image = placeholder

        // Verifica se a imagem já está no cache
        if let cachedImage = ImageCache.shared.getImage(forKey: url.absoluteString) {
            self.image = cachedImage
            completionHandler?(.success(cachedImage))
            return
        }

        // Baixa a imagem de forma assíncrona
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
          // Garante que `self` ainda está disponível
          guard let self else {
              completionHandler?(.failure(.unknownError))
              return
          }

            DispatchQueue.main.async {
                // Tratamento de erro genérico
                if let error = error {
                    self.image = errorImage
                    completionHandler?(.failure(.networkError(error)))
                    return
                }

                // Verifica o status da resposta
                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    self.image = errorImage
                    completionHandler?(.failure(.invalidResponse(httpResponse.statusCode)))
                    return
                }

                // Verifica se os dados são válidos
                guard let data = data, let image = UIImage(data: data) else {
                    self.image = errorImage
                    completionHandler?(.failure(.invalidData))
                    return
                }

                // Salva no cache e define a imagem
                ImageCache.shared.setImage(image: image, forKey: url.absoluteString)
                self.image = image
                completionHandler?(.success(image))
            }
        }.resume()
    }
}

// Enum que representa os possíveis erros ao carregar uma imagem
enum ImageLoadingError: Error {
    case networkError(Error) // Erro de rede
    case invalidResponse(Int) // Resposta HTTP inválida
    case invalidData // Dados inválidos
    case unknownError // Erro desconhecido
}
