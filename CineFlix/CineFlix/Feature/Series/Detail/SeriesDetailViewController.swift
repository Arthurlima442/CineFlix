//
//  SeriesDetailViewController.swift
//  CineFlix
//
//  Created by Arthur Lima on 10/01/2025.
//

import UIKit

class SeriesDetailViewController: UIViewController {
    var screen: SeriesDetailScreen?
    var viewModel: SeriesDetailViewModel
    
    init(idSeries: Int) {
        self.viewModel = SeriesDetailViewModel(idSeries: idSeries)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        screen = SeriesDetailScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        configNavigation()
        fetchRequest()
        setupBackButtonTitle()
    }
    
    func configNavigation() {
        navigationController?.isNavigationBarHidden = false

        let ap = UINavigationBarAppearance()
        ap.configureWithOpaqueBackground()
        ap.backgroundColor = .black

        navigationItem.standardAppearance = ap
        navigationItem.scrollEdgeAppearance = ap
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupBackButtonTitle() {
        navigationItem.backButtonTitle = "Voltar"
    }
    
    func configTableView() {
        screen?.configTableViewProtocols(delegate: self, dataSource: self)
        self.screen?.tableView.reloadData()
    }
    
    func fetchRequest() {
        viewModel.fetchDetail()
    }
    
    func configViewModel() {
        viewModel.delegate = self
    }
}

extension SeriesDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SeriesImageTableViewCell.identifier, for: indexPath) as? SeriesImageTableViewCell

            guard let seriesDetail = viewModel.getSeriesDetail else { return UITableViewCell() }
            cell?.setupCell(seriesData: seriesDetail)
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SeriesInformationTableViewCell.identifier, for: indexPath) as? SeriesInformationTableViewCell
            guard let seriesDetail = viewModel.getSeriesDetail else { return UITableViewCell() }
            cell?.setupCell(series: seriesDetail)
            return cell ?? UITableViewCell()
        }
    }
}

extension SeriesDetailViewController: SeriesDetailViewModelProtocol {
    func startLoading() {
        
    }
    
    func stopLoading() {
        
    }
    
    func success() {
        configTableView()
    }
    
    func failure() {
        configTableView()
    }
}
