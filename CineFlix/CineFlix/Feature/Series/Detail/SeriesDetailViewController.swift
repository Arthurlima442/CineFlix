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
        return 5 // Header + Actions + Synopsis + Info + WatchProviders
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let seriesDetail = viewModel.getSeriesDetail else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            // Header Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: SeriesDetailHeaderCell.identifier, for: indexPath) as? SeriesDetailHeaderCell
            cell?.configure(with: seriesDetail)
            return cell ?? UITableViewCell()
            
        case 1:
            // Actions Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: SeriesDetailActionsCell.identifier, for: indexPath) as? SeriesDetailActionsCell
            cell?.delegate = self
            return cell ?? UITableViewCell()
            
        case 2:
            // Synopsis Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: SeriesDetailSynopsisCell.identifier, for: indexPath) as? SeriesDetailSynopsisCell
            cell?.configure(with: seriesDetail.overview)
            return cell ?? UITableViewCell()
            
        case 3:
            // Info Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: SeriesDetailInfoCell.identifier, for: indexPath) as? SeriesDetailInfoCell
            cell?.configure(with: seriesDetail)
            return cell ?? UITableViewCell()
            
        case 4:
            // Watch Providers Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: SeriesDetailWatchProvidersCell.identifier, for: indexPath) as? SeriesDetailWatchProvidersCell
            cell?.configure(with: seriesDetail.watchProviders)
            return cell ?? UITableViewCell()
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 390 // Header (backdrop + poster + info)
        case 1:
            return 70 // Actions buttons
        case 2:
            return 180 // Synopsis
        case 3:
            return UITableView.automaticDimension
        case 4:
            return UITableView.automaticDimension // Watch Providers (adaptive height)
        default:
            return UITableView.automaticDimension
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

extension SeriesDetailViewController: SeriesDetailActionsCellDelegate {
    func playButtonTapped() {
        guard let seriesDetail = viewModel.getSeriesDetail,
              let videos = seriesDetail.videos?.results,
              let trailer = videos.first(where: { $0.type == "Trailer" }) ?? videos.first else {
            showAlert(title: "Indisponível", message: "Trailer não disponível para esta série.")
            return
        }
        
        let youtubeURL = "https://www.youtube.com/watch?v=\(trailer.key)"
        if let url = URL(string: youtubeURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func favoriteButtonTapped() {
        print("Favorite tapped")
    }
    
    func shareButtonTapped() {
        guard let seriesDetail = viewModel.getSeriesDetail else { return }
        
        var shareText = "\(seriesDetail.name)\n"
        shareText += "⭐ \(String(format: "%.1f", seriesDetail.voteAverage))/10\n"
        shareText += "Desde \(seriesDetail.firstAirDate)\n"
        
        // Adiciona sinopse curta
        let synopsisCurta = seriesDetail.overview.prefix(150)
        shareText += "\n\(synopsisCurta)...\n"
        
        // Adiciona trailer se disponível
        var shareItems: [Any] = [shareText]
        if let videos = seriesDetail.videos?.results,
           let trailer = videos.first(where: { $0.type == "Trailer" }) ?? videos.first,
           let trailerURL = URL(string: "https://www.youtube.com/watch?v=\(trailer.key)") {
            shareItems.append(trailerURL)
        }
        
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

