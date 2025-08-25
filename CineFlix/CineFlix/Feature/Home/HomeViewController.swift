//
//  HomeViewController.swift
//  CineFlix
//
//  Created by Arthur Lima on 09/06/2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let transitionDelegate = LeftSideTransitioningDelegate()
    var screen: HomeMovieScreen?
    private var viewModel: HomeViewModel = HomeViewModel()
    var movies: [MovieSummary] = []
    
    override func loadView() {
        screen = HomeMovieScreen()
        view = screen
        screen?.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleNav()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleNav()
        configSearch()
        configScreen()
        configTableView()
        configViewModel()
        viewModel.fetchPopularMovie()
    }
    
    func titleNav() {
        title = "CineFlix"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black  // cor do fundo da Home
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.red,
            .font: UIFont.systemFont(ofSize: 35, weight: .bold)
        ]
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func configSearch() {
        screen?.searchBar.delegate = self
    }
    
    func configScreen() {
        screen?.delegate = self
    }
    
    func configViewModel() {
        viewModel.delegate = self
    }
    
    func configTableView() {
        screen?.configTableViewProtocols(delegate: self, dataSource: self)
    }
}

extension HomeViewController: HomeMovieScreenProtocol {
    func tappedPresentCategoryMenu() {
        let categoryVC = CategoryMenuViewController(genre: viewModel.movieGenre)
        categoryVC.delegate = self
        categoryVC.modalPresentationStyle = .custom
        categoryVC.transitioningDelegate = transitionDelegate
        present(categoryVC, animated: true)
    }
}

extension HomeViewController: HomeViewModelProtocol {
    func success() {
        screen?.tableView.reloadData()
    }
    
    func failure() {
        screen?.tableView.reloadData()
    }
    
    func startLoading() {
        // start
    }
    
    func stopLoading() {
        // stop
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfNames()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isError {
            let cell = tableView.dequeueReusableCell(withIdentifier: ErrorTableViewCell.identifier, for: indexPath) as? ErrorTableViewCell
            cell?.setupCell(message: "Infelizmente tivemos um erro, tente novamente mais tarde")
            return cell ?? UITableViewCell()
        } else if viewModel.isNamesEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.identifier, for: indexPath) as? EmptyTableViewCell
            cell?.setupCell(message: "Não encontramos nenhum filme")
            return cell ?? UITableViewCell()
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
                return UITableViewCell()
            }
            cell.setupCell(movieData: viewModel.loudCurrentMovieSection(indexPath: indexPath))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.loudCurrentMovieSection(indexPath: indexPath)
        navigationController?.pushViewController(MovieDetailViewController(idMovie: movie.id), animated: true)
        navigationItem.backButtonTitle = "Voltar"
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchMovie(movie: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: CategoryMenuViewControllerProtocol {
    func selectCategory(genreItem: GenreItem) {
        viewModel.fetchGenre(genre: genreItem)
        
    }
}
