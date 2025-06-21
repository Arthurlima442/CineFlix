//
//  DetailViewController.swift
//  CineFlix
//
//  Created by Arthur Lima on 21/06/2025.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var screen: MovieDetailScreen?
    
    override func loadView() {
        screen = MovieDetailScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieImageTableViewCell.identifier, for: indexPath) as? MovieImageTableViewCell
        return cell ?? UITableViewCell()
    }
}

