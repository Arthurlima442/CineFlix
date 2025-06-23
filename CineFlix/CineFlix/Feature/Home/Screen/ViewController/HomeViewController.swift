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
    
    private var sections: [MovieSection] = [
        MovieSection(title: "Lançados recentemente:", items: ["coverSuperman", "lastofus", "mufasa"]),
        MovieSection(title: "Também nos cinemas:", items: ["warrior", "fire", "tickets"]),
        MovieSection(title: "Recomendados para você:", items: ["batman", "barbie", "matrix"])
    ]
    
    override func loadView() {
        screen = HomeMovieScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configScreen()
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // pode ter várias seções se quiser
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCarouselTableViewCell.identifier, for: indexPath) as? MovieCarouselTableViewCell else {
            return UITableViewCell()
        }

        let section = sections[indexPath.row]
        cell.configure(movieSection: section)
        cell.delegate = self
        return cell
    }
    }


extension HomeViewController: MovieCarouselTableViewCellProtocol {
    func tappedMovie() {
        navigationController?.pushViewController(MovieDetailViewController(), animated: true)
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


