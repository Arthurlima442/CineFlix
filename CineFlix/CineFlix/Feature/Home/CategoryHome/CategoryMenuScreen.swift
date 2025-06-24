//
//  CategoryMenuScreen.swift
//  CineFlix
//
//  Created by Arthur Lima on 23/06/2025.
//

import UIKit

class CategoryMenuScreen: UIView {
    
    var screen: CategoryMenuScreen?
    
    let categories = [
        "Kids", "Comedy", "Action", "Adventure",
            "Science Fiction", "Horror", "Thriller",
            "Family", "Western", "Drama",
            "War", "Romance", "Fantasy", "Music"
    ]
    
    lazy var categoryLabel: UILabel = {
       let category = UILabel()
        category.translatesAutoresizingMaskIntoConstraints = false
        category.text = "Categorys:"
        category.textColor = .white
        category.font = .systemFont(ofSize: 25, weight: .bold)
        category.textAlignment = .left
        return category
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "arrow.left.square")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .black
        table.separatorStyle = .none
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubview(tableView)
        addSubview(closeButton)
        addSubview(categoryLabel)
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

