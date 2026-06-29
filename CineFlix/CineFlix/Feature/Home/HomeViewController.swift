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
        
        // Load initial sections and data (optimized: load only 4 main sections)
        viewModel.setupInitialSections()
        viewModel.loadMainSectionsOnly()
        
        // Preload all genres in background after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.viewModel.preloadAllGenres()
        }
    }
    
    func titleNav() {
        title = "Filmes"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
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
        screen?.tableView.delegate = self
    }
}

extension HomeViewController: HomeMovieScreenProtocol {
    func tappedPresentCategoryMenu() {
        let categoryVC = CategoryMenuViewController()
        categoryVC.delegate = self
        categoryVC.modalPresentationStyle = .custom
        categoryVC.transitioningDelegate = transitionDelegate
        present(categoryVC, animated: true)
    }
}

extension HomeViewController: HomeViewModelProtocol {
    func success() {
        DispatchQueue.main.async {
            // Reset scroll to top when entering search mode
            if self.viewModel.isSearching {
                self.screen?.tableView.setContentOffset(.zero, animated: false)
            }
            self.screen?.tableView.reloadData()
        }
    }
    
    func failure() {
        DispatchQueue.main.async {
            self.screen?.tableView.reloadData()
        }
    }
    
    func updateSection(at index: Int) {
        DispatchQueue.main.async {
            guard index >= 0, index < self.viewModel.numberOfSections() else { return }
            let indexPath = IndexPath(row: 0, section: index)
            self.screen?.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func startLoading() {
        // Could show loading indicator here
    }
    
    func stopLoading() {
        // Could hide loading indicator here
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.isSearching {
            return 1
        }
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isSearching {
            return viewModel.searchResults.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.isSearching {
            return 180
        }
        return 320
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Modo Search - TableView simples com MovieTableViewCell
        if viewModel.isSearching {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
                return UITableViewCell()
            }
            
            guard indexPath.row >= 0, indexPath.row < viewModel.searchResults.count else {
                return UITableViewCell()
            }
            
            let movie = viewModel.searchResults[indexPath.row]
            cell.setupCell(movieData: movie)
            cell.selectionStyle = .none
            
            return cell
        }
        
        // Modo Normal - Categorias com CollectionView
        let sectionIndex = indexPath.section
        guard let section = viewModel.getSection(at: sectionIndex) else {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieSectionTableViewCell.identifier, for: indexPath) as? MovieSectionTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: section, sectionIndex: sectionIndex)
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Se está em modo search, navegar para detalhe do filme
        if viewModel.isSearching {
            guard indexPath.row >= 0, indexPath.row < viewModel.searchResults.count else { return }
            let movie = viewModel.searchResults[indexPath.row]
            navigationController?.pushViewController(MovieDetailViewController(idMovie: movie.id), animated: true)
            navigationItem.backButtonTitle = "Voltar"
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.searchMovies(query: "")
        } else {
            viewModel.searchMovies(query: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: CategoryMenuViewControllerProtocol {
    func selectCategory(genreItem: GenreItem) {
        // Limpar search antes de filtrar
        if viewModel.isSearching {
            viewModel.clearSearch()
        }
        
        // Filtrar por gênero
        viewModel.filterByGenre(genreItem.genre)
        
        screen?.tableView.setContentOffset(.zero, animated: false)
        DispatchQueue.main.async {
            self.screen?.tableView.reloadData()
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Eager loading: All sections are preloaded in background
        // No need to load sections on demand during scroll
        // This eliminates the "scrollViewDidScroll trap" that caused flickering
    }
}

extension HomeViewController: MovieSectionTableViewCellDelegate {
    func movieSectionCell(_ cell: MovieSectionTableViewCell, didSelectMovieAt index: Int, sectionIndex: Int) {
        if viewModel.isSearching {
            if let movie = viewModel.searchResults[safe: index] {
                navigationController?.pushViewController(MovieDetailViewController(idMovie: movie.id), animated: true)
                navigationItem.backButtonTitle = "Voltar"
            }
        } else {
            if let movie = viewModel.getMovieInSection(sectionIndex, row: index) {
                navigationController?.pushViewController(MovieDetailViewController(idMovie: movie.id), animated: true)
                navigationItem.backButtonTitle = "Voltar"
            }
        }
    }
    
    func movieSectionCell(_ cell: MovieSectionTableViewCell, shouldLoadMoreAt index: Int) {
        viewModel.loadMoreForSection(at: index)
    }
}
