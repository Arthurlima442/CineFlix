//
//  Category.swift
//  CineFlix
//
//  Created by Arthur Lima on 08/07/2025.
//
import Foundation

protocol CategoryMenuViewModelProtocol: AnyObject {
    func startLoading()
    func stopLoading()
    func successCategory()
    func failure(message: String)
}

class CategoryMenuViewModel {
    
    private var category: [String] = []
    weak var delegate: CategoryMenuViewModelProtocol?
    
    func fetchMovieMock() {
        delegate?.startLoading()
        LocalFileReader.loadJSON(fileName: "categories", type: CategoryList.self) { result in
            self.delegate?.stopLoading()
            switch result {
            case .success(let success):
                self.category = success.categories
                self.delegate?.successCategory()
            case .failure(let failure):
                print("Deu ruim: \(failure.errorDescription ?? "")")
                self.delegate?.failure(message: failure.errorDescription ?? "")
            }
        }
    }
    
    var numberOfRowsInSection: Int {
        return category.count
    }
    
    func loudCurrentMovieSection(indexPath: IndexPath) -> String {
        return category[indexPath.row]
    }
}
