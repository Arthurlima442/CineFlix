//
//  DetailViewController.swift
//  CineFlix
//
//  Created by Arthur Lima on 21/06/2025.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var screen: MovieDetailScreen?
    var viewModel: MovieDetailViewModel
    
    init(movie: Movie) {
        self.viewModel = MovieDetailViewModel(movie: movie)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        screen = MovieDetailScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configNavigation()
    }
    
    func configNavigation() {
        // Esconder botao padrao de voltar
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.view.backgroundColor = .black
    }
    
    func configTableView() {
        screen?.configTableViewProtocols(delegate: self, dataSource: self)
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieImageTableViewCell.identifier, for: indexPath) as? MovieImageTableViewCell
            cell?.delegate = self
            cell?.setupCell(movie: viewModel.getMovie)
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieInformationTableViewCell.identifier, for: indexPath) as? MovieInformationTableViewCell
            cell?.setupCell(movie: viewModel.getMovie)
            return cell ?? UITableViewCell()
        }
    }
}

extension MovieDetailViewController: MovieImageTableViewCellProtocol {
    func tappedBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
