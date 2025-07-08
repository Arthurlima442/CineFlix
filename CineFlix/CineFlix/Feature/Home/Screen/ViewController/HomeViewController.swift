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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configScreen()
        view.backgroundColor = .black
        
        // ← ESSENCIAL
        if let screen = screen {
            screen.frame = UIScreen.main.bounds
            screen.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            screen.backgroundColor = .black
        }
    }

    func configScreen() {
        screen?.delegate = self
    }
    
    func configTableView() {
        // primeira opcao CASO VOCÊ NÃO QUEIRA CRIAR O METODO
        // screen?.tableView.delegate = self
        // screen?.tableView.dataSource = self
        
        // segunda opcao com o metodo
        screen?.configTableViewProtocols(delegate: self, dataSource: self)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCarouselTableViewCell.identifier, for: indexPath) as? MovieCarouselTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(movieSection: viewModel.loudCurrentMovieSection(indexPath: indexPath), delegate: self)
        return cell
    }
}

extension HomeViewController: MovieCarouselTableViewCellProtocol {
    func tappedMovie(movie: Movie) {
        navigationController?.pushViewController(MovieDetailViewController(movie: movie), animated: true)
    }
}
extension HomeViewController: HomeMovieScreenProtocol {
    func tappedPresentCategoryMenu() {
        let categoryVC = CategoryMenuViewController()
        categoryVC.modalPresentationStyle = .custom
        categoryVC.transitioningDelegate = transitionDelegate
        present(categoryVC, animated: true)
    }
}


