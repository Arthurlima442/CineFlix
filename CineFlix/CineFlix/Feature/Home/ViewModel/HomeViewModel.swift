//
//  HomeViewModel.swift
//  CineFlix
//
//  Created by Arthur Lima on 08/07/2025.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    func startLoading()
    func stopLoading()
    func successMovie()
    func failure(message: String)
}

class HomeViewModel {
    private var sections: [MovieSection] = []
    weak var delegate: HomeViewModelProtocol?
    
    func fetchMovieMock() {
        delegate?.startLoading()
        LocalFileReader.loadJSON(fileName: "movieSection", type: [MovieSection].self) { result in
            self.delegate?.stopLoading()
            switch result {
            case .success(let success):
                self.sections = success
                self.delegate?.successMovie()
            case .failure(let failure):
                print("Deu ruim: \(failure.errorDescription ?? "")")
                self.delegate?.failure(message: failure.errorDescription ?? "")
            }
        }
    }
    
    var numberOfRowsInSection: Int {
        return sections.count
    }
    
    func loudCurrentMovieSection(indexPath: IndexPath) -> MovieSection {
        return sections[indexPath.row]
    }
}
