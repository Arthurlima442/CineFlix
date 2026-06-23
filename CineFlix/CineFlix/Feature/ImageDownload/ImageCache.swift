//
//  ImageCacheManager.swift
//  Movie
//
//  Created by Arthur Lima on 02/08/2025.
//

import UIKit

class ImageCache {
  static let shared = ImageCache() // Singleton
  private let cache = NSCache<NSString, UIImage>() // Cache de memória
  private let cacheQueue = DispatchQueue(label: "ImageCache.ioQueue") // Fila para operações seguras

  private init() {
    cache.countLimit = 100 // Limite otimizado para performance
  }

  /// Limpa todas as imagens armazenadas no cache de forma assíncrona
  /// Você pode utilizar esse método em qualquer lugar quando quiser deletar tudo do cache
  func clearCache() {
    cacheQueue.async { [weak self] in
      guard let self else { return }
      self.cache.removeAllObjects()
      print("Cache limpo!")
    }
  }

  /// Define o limite máximo de itens no cache
  func setCacheLimited(value: Int) {
    cacheQueue.async { [weak self] in
      guard let self else { return }
      self.cache.countLimit = value
      print("Novo limite de cache definido: \(value)")
    }
  }

  /// Adiciona uma imagem ao cache para uma chave específica
  func setImage(image: UIImage, forKey key: String) {
    cacheQueue.async { [weak self] in
      guard let self else { return }
      self.cache.setObject(image, forKey: key as NSString)
    }
  }

  /// Recupera uma imagem do cache de forma segura para threads
  func getImage(forKey key: String) -> UIImage? {
    return cacheQueue.sync { [weak self] in
      guard let self else { return nil }
      return cache.object(forKey: key as NSString)
    }
  }
}
