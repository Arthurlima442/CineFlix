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
    
    lazy var cineFlixLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "CineFlix"
        text.font = UIFont.systemFont(ofSize: 45)
        text.textColor = .red
        text.textAlignment = .center
        text.backgroundColor = .black
        return text
    }()
    
    lazy var searchTextField: UITextField = {
        let search = UITextField()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.borderStyle = .roundedRect
        search.clipsToBounds = true
        search.layer.cornerRadius = 4
        search.layer.borderColor = UIColor.white.cgColor
        search.layer.borderWidth = 1
        search.backgroundColor = .black
        search.textColor = .white
        // Placeholder branco
        search.attributedPlaceholder = NSAttributedString(
            string: "Search movie:",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
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
        tableView.register(MovieCarouselTableViewCell.self, forCellReuseIdentifier: MovieCarouselTableViewCell.identifier)
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
        addSubview(cineFlixLabel)
        addSubview(searchTextField)
        addSubview(menuButton)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            safeAreaTopBackground.topAnchor.constraint(equalTo: topAnchor),
            safeAreaTopBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            safeAreaTopBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            safeAreaTopBackground.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            cineFlixLabel.topAnchor.constraint(equalTo: safeAreaTopBackground.bottomAnchor, constant: 8),
            cineFlixLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cineFlixLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            cineFlixLabel.heightAnchor.constraint(equalToConstant: 40),
            
            menuButton.topAnchor.constraint(equalTo: safeAreaTopBackground.bottomAnchor),
            menuButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            searchTextField.topAnchor.constraint(equalTo: cineFlixLabel.bottomAnchor, constant: 25),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
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
