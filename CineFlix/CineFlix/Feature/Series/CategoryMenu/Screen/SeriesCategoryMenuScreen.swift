//
//  SeriesCategoryMenuScreen.swift
//  CineFlix
//
//  Created by Arthur Lima on 23/06/2026.
//

import UIKit

protocol SeriesCategoryMenuScreenProtocol: AnyObject {
    func tappedCloseButton()
}

class SeriesCategoryMenuScreen: UIView {
    
    weak var delegate: SeriesCategoryMenuScreenProtocol?
    
    lazy var categoryLabel: UILabel = {
        let category = UILabel()
        category.translatesAutoresizingMaskIntoConstraints = false
        category.text = "Gêneros:"
        category.textColor = .red
        category.font = .systemFont(ofSize: 25, weight: .bold)
        category.textAlignment = .left
        return category
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "arrow.left.square")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func closeButtonTapped() {
        delegate?.tappedCloseButton()
    }
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .black
        table.separatorStyle = .none
        table.register(SeriesCategoryTableViewCell.self, forCellReuseIdentifier: SeriesCategoryTableViewCell.identifier)
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addElements()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addElements() {
        addSubview(tableView)
        addSubview(closeButton)
        addSubview(categoryLabel)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            categoryLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            
            tableView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configTableViewProtocols(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
}
