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
        stopLoadingView()
        screen?.tableView.reloadData()
    }
    
    func failure() {
        stopLoadingView()
        screen?.tableView.reloadData()
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

extension SeriesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Load genre sections on demand as user scrolls vertically
        guard let tableView = screen?.tableView else { return }
        
        let visibleIndexPaths = tableView.indexPathsForVisibleRows ?? []
        for indexPath in visibleIndexPaths {
            let sectionIndex = indexPath.section
            
            // Load genre sections (index >= 3) on demand
            if sectionIndex >= 3 && sectionIndex < viewModel.numberOfSections() {
                viewModel.loadSectionIfNeeded(at: sectionIndex)
            }
        }
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


