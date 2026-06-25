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
    private var loadingView: UIView?
    
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
        viewModel.loadMainSectionsOnly()
        
        // Preload all genres in background after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.viewModel.preloadAllGenres()
        }
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
        // Reset scroll to top when entering search mode
        if viewModel.isSearching {
            DispatchQueue.main.async {
                self.screen?.tableView.setContentOffset(.zero, animated: false)
            }
        }
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
            guard index >= 0, index < self.viewModel.numberOfSections() else { return }
            let indexPath = IndexPath(row: 0, section: index)
            self.screen?.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func startLoading() {
        startLoadingView()
    }
    
    func stopLoading() {
        stopLoadingView()
    }
}

extension SeriesViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        // Modo Search - TableView simples com SeriesTableViewCell
        if viewModel.isSearching {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SeriesTableViewCell.identifier, for: indexPath) as? SeriesTableViewCell else {
                return UITableViewCell()
            }
            
            guard indexPath.row >= 0, indexPath.row < viewModel.searchResults.count else {
                return UITableViewCell()
            }
            
            let series = viewModel.searchResults[indexPath.row]
            cell.setupCell(seriesData: series)
            cell.selectionStyle = .none
            
            return cell
        }
        
        // Modo normal - Categorias com CollectionView
        let sectionIndex = indexPath.section
        guard let section = viewModel.getSection(at: sectionIndex) else {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SeriesSectionTableViewCell.identifier, for: indexPath) as? SeriesSectionTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: section, sectionIndex: sectionIndex)
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Se está em modo search, navegar para detalhe da série
        if viewModel.isSearching {
            guard indexPath.row >= 0, indexPath.row < viewModel.searchResults.count else { return }
            let series = viewModel.searchResults[indexPath.row]
            navigationController?.pushViewController(SeriesDetailViewController(idSeries: series.id), animated: true)
            navigationItem.backButtonTitle = "Voltar"
        }
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
        if viewModel.isSearching {
            viewModel.clearSearch()
        }
        
        if genreItem.genre == nil {
            // "Populares" foi selecionado - volta ao estado inicial
            viewModel.resetToAllCategories()
        } else {
            // Um gênero específico foi selecionado
            viewModel.filterByGenre(genreItem.genre!)
        }
        
        // Reset completo da TableView para garantir layout organizado
        screen?.tableView.setContentOffset(.zero, animated: false)
        DispatchQueue.main.async {
            self.screen?.tableView.reloadData()
        }
    }
}

extension SeriesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Eager loading with preloadAllGenres() makes on-demand loading unnecessary
        // All genre sections are preloaded in background with 200ms delays between requests
        // This prevents scroll trap and ensures smooth scrolling performance
    }
}

// MARK: - Loading Methods

extension SeriesViewController {
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
            label.text = "Carregando séries..."
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


