//
//  SeriesViewController.swift
//  CineFlix
//
//  Created by Arthur Lima on 23/06/2026.
//

import UIKit

class SeriesViewController: UIViewController {
    
    private let transitionDelegate = LeftSideTransitioningDelegate()
    var screen: SeriesScreen?
    private var viewModel: SeriesViewModel = SeriesViewModel()
    
    override func loadView() {
        screen = SeriesScreen()
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
        setupInitialSections()
    }
    
    // MARK: - Setup
    
    private func setupInitialSections() {
        viewModel.setupInitialSections()
        viewModel.loadAllSections()
    }
    
    func titleNav() {
        title = "Séries"
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

extension SeriesViewController: SeriesScreenProtocol {
    func tappedPresentCategoryMenu() {
        let categoryVC = SeriesCategoryMenuViewController()
        categoryVC.delegate = self
        categoryVC.modalPresentationStyle = .custom
        categoryVC.transitioningDelegate = transitionDelegate
        present(categoryVC, animated: true)
    }
}

extension SeriesViewController: SeriesViewModelProtocol {
    func success() {
        screen?.tableView.reloadData()
    }
    
    func failure() {
        screen?.tableView.reloadData()
    }
    
    func startLoading() {
        // start loading
    }
    
    func stopLoading() {
        // stop loading
    }
}

extension SeriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Each section has 1 row (the section cell with horizontal collection view)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320 // Altura para acomodar título + CollectionView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = viewModel.getSection(at: indexPath.section) else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SeriesSectionTableViewCell.identifier, for: indexPath) as! SeriesSectionTableViewCell
        cell.configure(with: section, sectionIndex: indexPath.section)
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
}

extension SeriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchSeries(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - SeriesSectionTableViewCellDelegate

extension SeriesViewController: SeriesSectionTableViewCellDelegate {
    
    func seriesSectionCell(_ cell: SeriesSectionTableViewCell, didSelectSeriesAt index: Int) {
        guard let indexPath = screen?.tableView.indexPath(for: cell) else { return }
        guard let series = viewModel.getSeriesInSection(indexPath.section, row: index) else { return }
        
        navigationController?.pushViewController(SeriesDetailViewController(idSeries: series.id), animated: true)
        navigationItem.backButtonTitle = "Voltar"
    }
    
    func seriesSectionCell(_ cell: SeriesSectionTableViewCell, shouldLoadMoreAt index: Int) {
        viewModel.loadMoreForSection(at: index)
    }
}

extension SeriesViewController: SeriesCategoryMenuViewControllerProtocol {
    func selectCategory(genreItem: SeriesGenreItem) {
        if genreItem.genre == nil {
            // "Populares" foi selecionado - volta ao estado inicial
            viewModel.resetToAllCategories()
        } else {
            // Um gênero específico foi selecionado
            viewModel.filterByGenre(genreItem.genre!)
        }
        
        // Reset completo da TableView para garantir layout organizado
        screen?.tableView.setContentOffset(.zero, animated: false)
        screen?.tableView.reloadData()
    }
}


