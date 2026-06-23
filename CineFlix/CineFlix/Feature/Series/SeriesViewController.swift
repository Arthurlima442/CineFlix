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
        viewModel.fetchPopularSeries()
    }
    
    func titleNav() {
        title = "CineFlix"
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
        let categoryVC = SeriesCategoryMenuViewController(genre: viewModel.seriesGenre)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfNames()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isError {
            let cell = tableView.dequeueReusableCell(withIdentifier: ErrorSeriesTableViewCell.identifier, for: indexPath) as? ErrorSeriesTableViewCell
            cell?.setupCell(message: "Infelizmente tivemos um erro, tente novamente mais tarde")
            return cell ?? UITableViewCell()
        } else if viewModel.isNamesEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptySeriesTableViewCell.identifier, for: indexPath) as? EmptySeriesTableViewCell
            cell?.setupCell(with: "Nenhuma série encontrada")
            return cell ?? UITableViewCell()
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SeriesTableViewCell.identifier, for: indexPath) as? SeriesTableViewCell else {
                return UITableViewCell()
            }
            cell.setupCell(seriesData: viewModel.loadCurrentSeriesSection(indexPath: indexPath))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let series = viewModel.loadCurrentSeriesSection(indexPath: indexPath)
        navigationController?.pushViewController(SeriesDetailViewController(idSeries: series.id), animated: true)
        navigationItem.backButtonTitle = "Voltar"
    }
}

extension SeriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchSeries(series: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SeriesViewController: SeriesCategoryMenuViewControllerProtocol {
    func selectCategory(genreItem: SeriesGenreItem) {
        viewModel.fetchGenre(genre: genreItem)
    }
}

extension SeriesViewController: UIScrollViewDelegate {
    /// Detecta quando o usuário fez scroll perto do final da TableView
    /// e carrega a próxima página de séries (scroll infinito)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        // Se o usuário está a 200pt do final, carrega a próxima página
        let threshold: CGFloat = 200
        
        if offsetY > contentHeight - frameHeight - threshold {
            viewModel.fetchNextPage()
        }
    }
}
