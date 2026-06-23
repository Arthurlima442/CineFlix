//
//  HomeScreen.swift
//  CineFlix
//
//  Created by Arthur Lima on 09/06/2025.
//
import UIKit

protocol HomeMovieScreenProtocol: AnyObject {
    func tappedPresentCategoryMenu()
}

class HomeMovieScreen: UIView {
    
    weak var delegate: HomeMovieScreenProtocol?
    
    lazy var safeAreaTopBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.placeholder = "Search movie"
        search.searchBarStyle = .minimal
        search.barTintColor = .black
        search.backgroundColor = .black
        
        // Estilo do campo de texto
        if let textField = search.searchTextField as UITextField? {
            textField.textColor = .white
            textField.backgroundColor = UIColor.darkGray
            textField.layer.cornerRadius = 10
            textField.layer.masksToBounds = true
            
            // Placeholder branco
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search movie",
                attributes: [
                    .foregroundColor: UIColor.white.withAlphaComponent(0.8)
                ]
            )
        }
        return search
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "line.3.horizontal") // ou uma imagem customizada
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedPresentCategoryMenu), for: .touchUpInside)
        return button
    }()
    
    @objc func tappedPresentCategoryMenu() {
        delegate?.tappedPresentCategoryMenu()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.register(MovieSectionTableViewCell.self, forCellReuseIdentifier: MovieSectionTableViewCell.identifier)
        tableView.register(ErrorTableViewCell.self, forCellReuseIdentifier: ErrorTableViewCell.identifier)
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.identifier)
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.alwaysBounceVertical = false
        tableView.contentInsetAdjustmentBehavior = .never // ← ESSENCIAL!
        return tableView
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .black
        addElements()
        configConstraints()
        clipsToBounds = true // ← ESSENCIAL
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addElements() {
        addSubview(safeAreaTopBackground)
        addSubview(tableView)
        addSubview(searchBar)
        addSubview(menuButton)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            safeAreaTopBackground.topAnchor.constraint(equalTo: topAnchor),
            safeAreaTopBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            safeAreaTopBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            safeAreaTopBackground.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            menuButton.topAnchor.constraint(equalTo: safeAreaTopBackground.bottomAnchor),
            menuButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            searchBar.topAnchor.constraint(equalTo: menuButton.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configTableViewProtocols(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
}
