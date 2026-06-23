//
//  AsyncImageLoader.swift
//  Movie
//
//  Created by Arthur Lima on 02/08/2025.
//

import UIKit
import ObjectiveC

// MARK: - Associated Object Key for storing download task
private var imageDownloadTaskKey: UInt8 = 0

extension UIImageView {
    
    /// Stored property to track the current download task for this image view
    var imageDownloadTask: URLSessionDataTask? {
        get {
            return objc_getAssociatedObject(self, &imageDownloadTaskKey) as? URLSessionDataTask
        }
        set {
            objc_setAssociatedObject(self, &imageDownloadTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// Carrega uma imagem de forma assíncrona a partir de uma URL, com suporte a placeholder, imagem de erro e cache.
    /// Cancela downloads anteriores para evitar reuso desnecessário de células
    func loadImageFromURL(from url: URL,
                   placeholder: UIImage? = nil,
                   errorImage: UIImage? = nil,
                   completionHandler: ((Result<UIImage, ImageLoadingError>) -> Void)? = nil) {
        // Cancela qualquer download anterior para evitar atualizações de células recicladas
        imageDownloadTask?.cancel()
        
        // Define a imagem placeholder inicialmente
        self.image = placeholder

        // Verifica se a imagem já está no cache
        if let cachedImage = ImageCache.shared.getImage(forKey: url.absoluteString) {
            self.image = cachedImage
            self.imageDownloadTask = nil
            completionHandler?(.success(cachedImage))
            return
        }

        // Baixa a imagem de forma assíncrona
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            // Garante que `self` ainda está disponível
            guard let self else {
                completionHandler?(.failure(.unknownError))
                return
            }

            // Verifica se a tarefa foi cancelada
            if let error = error as? URLError, error.code == .cancelled {
                completionHandler?(.failure(.downloadCancelled))
                return
            }

            DispatchQueue.main.async {
                // Tratamento de erro genérico
                if let error = error {
                    self.image = errorImage
                    self.imageDownloadTask = nil
                    completionHandler?(.failure(.networkError(error)))
                    return
                }

                // Verifica o status da resposta
                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    self.image = errorImage
                    self.imageDownloadTask = nil
                    completionHandler?(.failure(.invalidResponse(httpResponse.statusCode)))
                    return
                }

                // Verifica se os dados são válidos
                guard let data = data, let image = UIImage(data: data) else {
                    self.image = errorImage
                    self.imageDownloadTask = nil
                    completionHandler?(.failure(.invalidData))
                    return
                }

                // Salva no cache e define a imagem
                ImageCache.shared.setImage(image: image, forKey: url.absoluteString)
                self.image = image
                self.imageDownloadTask = nil
                completionHandler?(.success(image))
            }
        }
        
        // Armazena a tarefa para que possa ser cancelada depois
        self.imageDownloadTask = task
        task.resume()
    }
}

// Enum que representa os possíveis erros ao carregar uma imagem
enum ImageLoadingError: Error {
    case networkError(Error) // Erro de rede
    case invalidResponse(Int) // Resposta HTTP inválida
    case invalidData // Dados inválidos
    case unknownError // Erro desconhecido
    case downloadCancelled // Download foi cancelado
}
