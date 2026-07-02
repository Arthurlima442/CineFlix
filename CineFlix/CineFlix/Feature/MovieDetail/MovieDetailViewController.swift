//
//  DetailViewController.swift
//  CineFlix
//
//  Created by Arthur Lima on 21/06/2025.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var screen: MovieDetailScreen?
    var viewModel: MovieDetailViewModel
    
    init(idMovie: Int) {
        self.viewModel = MovieDetailViewModel(idMovie: idMovie)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        screen = MovieDetailScreen()
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

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // Header + Actions + Synopsis + Info + WatchProviders
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieDetail = viewModel.getMovieDetail else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            // Header Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailHeaderCell.identifier, for: indexPath) as? MovieDetailHeaderCell
            cell?.configure(with: movieDetail)
            return cell ?? UITableViewCell()
            
        case 1:
            // Actions Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailActionsCell.identifier, for: indexPath) as? MovieDetailActionsCell
            cell?.delegate = self
            return cell ?? UITableViewCell()
            
        case 2:
            // Synopsis Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailSynopsisCell.identifier, for: indexPath) as? MovieDetailSynopsisCell
            cell?.configure(with: movieDetail.overview)
            return cell ?? UITableViewCell()
            
        case 3:
            // Info Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailInfoCell.identifier, for: indexPath) as? MovieDetailInfoCell
            cell?.configure(with: movieDetail)
            return cell ?? UITableViewCell()
            
        case 4:
            // Watch Providers Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailWatchProvidersCell.identifier, for: indexPath) as? MovieDetailWatchProvidersCell
            cell?.configure(with: movieDetail.watchProviders)
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

extension MovieDetailViewController: MovieDetailViewModelProtocol {
    func startLoading() {
        // Show loading indicator if needed
    }
    
    func stopLoading() {
        // Hide loading indicator if needed
    }
    
    func success() {
        configTableView()
    }
    
    func failure() {
        configTableView()
    }
}

extension MovieDetailViewController: MovieDetailActionsCellDelegate {
    func playButtonTapped() {
        guard let movieDetail = viewModel.getMovieDetail,
              let videos = movieDetail.videos?.results,
              let trailer = videos.first(where: { $0.type == "Trailer" }) ?? videos.first else {
            showAlert(title: "Indisponível", message: "Trailer não disponível para este filme.")
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
        guard let movieDetail = viewModel.getMovieDetail else { return }
        
        var shareText = "\(movieDetail.title)\n"
        shareText += "⭐ \(String(format: "%.1f", movieDetail.voteAverage))/10\n"
        
        // Adiciona sinopse curta
        let synopsisCurta = movieDetail.overview.prefix(150)
        shareText += "\n\(synopsisCurta)...\n"
        
        // Adiciona trailer se disponível
        var shareItems: [Any] = [shareText]
        if let videos = movieDetail.videos?.results,
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

