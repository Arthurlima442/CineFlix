//
//  HomeViewController.swift
//  CineFlix
//
//  Created by Arthur Lima on 09/06/2025.
//

import UIKit

class HomeViewController: UIViewController {
   
    var screen: HomeMovieScreen?
    
    override func loadView() {
        screen = HomeMovieScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configScreen()
        configTableView()
        
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
        return 10 // por exemplo, 5 carrosséis
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200 // altura da célula que contém o carrossel
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCarouselTableViewCell
.identifier, for: indexPath) as? MovieCarouselTableViewCell
 else {
            return UITableViewCell()
        }
        cell.delegate = self
        
        cell.configure(with: ["Item 1", "Item 2", "Item 3","Item 4"]) // exemplo de dados
        return cell
    }
}

extension HomeViewController: MovieCarouselTableViewCellProtocol {
    func tappedMovie() {
        navigationController?.pushViewController(MovieDetailViewController(), animated: true)
    }
    
}

