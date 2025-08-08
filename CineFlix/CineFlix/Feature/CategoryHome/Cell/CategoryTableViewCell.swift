//
//  CategoryTableViewCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 08/07/2025.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: CategoryTableViewCell.self)
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .black
        addElements()
        configConstraints()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAppearance() {
        backgroundColor = .darkGray
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
    
    func addElements() {
        contentView.addSubview(titleLabel)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setupCell(genre: GenreItem) {
        titleLabel.text = genre.genre.rawValue
        titleLabel.textColor = genre.isSelected ? .black : .white
        backgroundColor = genre.isSelected ? .white : .black
    }
}
