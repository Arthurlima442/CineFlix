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
            self.screen?.tableView.reloadData()
        }
    }
    
    func failure() {
        DispatchQueue.main.async {
            self.screen?.tableView.reloadData()
        }
    }
    
    func updateSection(at index: Int) {
        // Atualizar apenas a célula específica (mais eficiente)
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: index, section: 0)
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionIndex = indexPath.row
        
        // If searching
        if viewModel.numberOfSections() == 1 && viewModel.searchResults.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.identifier, for: indexPath) as? EmptyTableViewCell
            cell?.setupCell(message: "Não encontramos nenhum filme")
            return cell ?? UITableViewCell()
        }
        
        // If searching and has results
        if viewModel.numberOfSections() == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieSectionTableViewCell.identifier, for: indexPath) as? MovieSectionTableViewCell else {
                return UITableViewCell()
            }
            
            // Create a temporary section for search results
            var searchSection = MovieSection(title: "Resultados", type: .popular)
            searchSection.movies = viewModel.searchResults
            
            cell.configure(with: searchSection, sectionIndex: sectionIndex)
            cell.delegate = self
            
            return cell
        }
        
        // Normal multi-section view
        if let section = viewModel.getSection(at: sectionIndex) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieSectionTableViewCell.identifier, for: indexPath) as? MovieSectionTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: section, sectionIndex: sectionIndex)
            cell.delegate = self
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        viewModel.filterByGenre(genreItem.genre)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Load genre sections on demand as user scrolls vertically
        guard let tableView = screen?.tableView else { return }
        
        let visibleIndexPaths = tableView.indexPathsForVisibleRows ?? []
        for indexPath in visibleIndexPaths {
            let sectionIndex = indexPath.row  // Correto: row because numberOfRowsInSection returns viewModel.numberOfSections()
            
            // Load genre sections (index >= 4) on demand
            if sectionIndex >= 4 && sectionIndex < viewModel.numberOfSections() {
                viewModel.loadSectionIfNeeded(at: sectionIndex)
            }
        }
    }
}

extension HomeViewController: MovieSectionTableViewCellDelegate {
    func movieSectionCell(_ cell: MovieSectionTableViewCell, didSelectMovieAt index: Int, sectionIndex: Int) {
        // Determine which movie was selected
        if viewModel.numberOfSections() == 1 {
            // Search results
            if let movie = viewModel.searchResults[safe: index] {
                navigationController?.pushViewController(MovieDetailViewController(idMovie: movie.id), animated: true)
                navigationItem.backButtonTitle = "Voltar"
            }
        } else {
            // Multi-section view
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
