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
    private var loadingView: UIView?
    
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
        startLoadingView()
    }
    
    func stopLoading() {
        stopLoadingView()
    }
    
    func success() {
        stopLoadingView()
        configTableView()
    }
    
    func failure() {
        stopLoadingView()
        configTableView()
    }
}

// MARK: - Loading Methods

extension SeriesDetailViewController {
    private func startLoadingView() {
        DispatchQueue.main.async {
            guard self.loadingView == nil else { return }
            
            let container = UIView()
            container.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            container.frame = self.view.bounds
            
            let spinner = UIView()
            spinner.layer.borderColor = UIColor(red: 1, green: 0.4, blue: 0.2, alpha: 1).cgColor
            spinner.layer.borderWidth = 3
            spinner.layer.cornerRadius = 35
            spinner.backgroundColor = .clear
            
            let label = UILabel()
            label.text = "Carregando detalhes..."
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            label.textAlignment = .center
            
            container.addSubview(spinner)
            container.addSubview(label)
            
            spinner.translatesAutoresizingMaskIntoConstraints = false
            label.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                spinner.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                spinner.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -30),
                spinner.widthAnchor.constraint(equalToConstant: 70),
                spinner.heightAnchor.constraint(equalToConstant: 70),
                
                label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                label.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 20),
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20)
            ])
            
            let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotation.toValue = CGFloat.pi * 2
            rotation.duration = 1.5
            rotation.timingFunction = CAMediaTimingFunction(name: .linear)
            rotation.repeatCount = .infinity
            spinner.layer.add(rotation, forKey: "rotation")
            
            self.view.addSubview(container)
            self.loadingView = container
        }
    }
    
    private func stopLoadingView() {
        DispatchQueue.main.async {
            guard let loading = self.loadingView else { return }
            UIView.animate(withDuration: 0.3, animations: {
                loading.alpha = 0
            }) { _ in
                loading.removeFromSuperview()
                self.loadingView = nil
            }
        }
    }
}
