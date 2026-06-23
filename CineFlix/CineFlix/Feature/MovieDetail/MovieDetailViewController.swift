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
        ap.backgroundColor = .black // ou a cor que quiser

        navigationItem.standardAppearance = ap
        navigationItem.scrollEdgeAppearance = ap   // <- mesma aparência no scroll
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
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieImageTableViewCell.identifier, for: indexPath) as? MovieImageTableViewCell

            guard let movieDetail = viewModel.getMovieDetail else { return UITableViewCell() }
            cell?.setupCell(movieData: movieDetail)
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieInformationTableViewCell.identifier, for: indexPath) as? MovieInformationTableViewCell
            guard let movieDetail = viewModel.getMovieDetail else { return UITableViewCell() }
            cell?.setupCell(movie: movieDetail)
            return cell ?? UITableViewCell()
        }
    }
}

extension MovieDetailViewController: MovieDetailViewModelProtocol {
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
