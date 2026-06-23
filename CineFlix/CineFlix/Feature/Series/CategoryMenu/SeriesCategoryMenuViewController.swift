//
//  SeriesCategoryMenuViewController.swift
//  CineFlix
//
//  Created by Arthur Lima on 23/06/2026.
//

import UIKit

protocol SeriesCategoryMenuViewControllerProtocol: AnyObject {
    func selectCategory(genreItem: SeriesGenreItem)
}

class SeriesCategoryMenuViewController: UIViewController {
    
    weak var delegate: SeriesCategoryMenuViewControllerProtocol?
    
    var screen: SeriesCategoryMenuScreen?
    private let viewModel: SeriesCategoryMenuViewModel
    
    init() {
        self.viewModel = SeriesCategoryMenuViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        screen = SeriesCategoryMenuScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configScreen()
        configViewModel()
    }
    
    func configScreen() {
        screen?.delegate = self
    }
    
    func configViewModel() {
        viewModel.delegate = self
    }
    
    func configTableView() {
        screen?.configTableViewProtocols(delegate: self, dataSource: self)
    }
}

extension SeriesCategoryMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfGenre()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SeriesCategoryTableViewCell.identifier, for: indexPath) as? SeriesCategoryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setupCell(genre: viewModel.loadCurrentGenre(at: indexPath.item))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let genreSelectedNow = viewModel.loadCurrentGenre(at: indexPath.row)
        delegate?.selectCategory(genreItem: genreSelectedNow)
        dismiss(animated: true)
    }
}

extension SeriesCategoryMenuViewController: SeriesCategoryMenuScreenProtocol {
    func tappedCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension SeriesCategoryMenuViewController: SeriesCategoryMenuViewModelProtocol {
    func startLoading() {
        //start
    }
    
    func stopLoading() {
        //stop
    }
    
    func successCategory() {
        screen?.tableView.reloadData()
    }
    
    func failure(message: String) {
        // alert
    }
}
