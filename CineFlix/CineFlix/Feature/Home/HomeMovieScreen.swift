//
//  HomeScreen.swift
//  CineFlix
//
//  Created by Arthur Lima on 09/06/2025.
//

import UIKit

class HomeMovieScreen: UIView {
    
    lazy var cineFlixLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "CineFlix"
        text.font = UIFont.systemFont(ofSize: 45)
        text.textColor = .red
        text.textAlignment = .center
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
            string: "search movie:",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        return search
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MovieCarouselTableViewCell
.self, forCellReuseIdentifier: MovieCarouselTableViewCell
.identifier)
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .black
        addElements()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addElements() {
        addSubview(tableView)
        addSubview(cineFlixLabel)
        addSubview(searchTextField)
    }
    
    func configTableViewProtocols(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            cineFlixLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            cineFlixLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cineFlixLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            cineFlixLabel.heightAnchor.constraint(equalToConstant: 40),
            
            searchTextField.topAnchor.constraint(equalTo: cineFlixLabel.bottomAnchor, constant: 25),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
