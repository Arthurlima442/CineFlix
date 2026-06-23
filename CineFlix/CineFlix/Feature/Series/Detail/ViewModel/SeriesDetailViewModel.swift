//
//  SeriesDetailViewModel.swift
//  CineFlix
//
//  Created by Arthur Lima on 10/01/2025.
//

import Foundation

protocol SeriesDetailViewModelProtocol: AnyObject {
    func success()
    func failure()
    func startLoading()
    func stopLoading()
}

class SeriesDetailViewModel {
    
    private let idSeries: Int
    private var service: SeriesService = SeriesService()
    private(set) var seriesDetail: SeriesDetail?
    weak var delegate: SeriesDetailViewModelProtocol?
    
    init(idSeries: Int) {
        self.idSeries = idSeries
    }
    
    var numberOfRowsInSection: Int {
        return 2
    }
    
    var getSeriesDetail: SeriesDetail? {
        return seriesDetail
    }
    
    func fetchDetail() {
        delegate?.startLoading()
        service.fetchSeriesDetail(by: idSeries) { result in
            switch result {
            case .success(let success):
                self.seriesDetail = success
                self.delegate?.success()
            case .failure:
                self.delegate?.failure()
            }
            self.delegate?.stopLoading()
        }
    }
}
