// filepath: EmptySeriesTableViewCell.swift
//
//  EmptySeriesTableViewCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 10/01/2025.
//

import UIKit

class EmptySeriesTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: EmptySeriesTableViewCell.self)
    
    lazy var emptyLabel: UILabel = {
        let empty = UILabel()
        empty.font = .systemFont(ofSize: 20, weight: .semibold)
        empty.textColor = .white
        empty.textAlignment = .center
        empty.translatesAutoresizingMaskIntoConstraints = false
        return empty
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .black
        addElements()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addElements() {
        contentView.addSubview(emptyLabel)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            emptyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            emptyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emptyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emptyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            emptyLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupCell(with message: String = "No series found") {
        emptyLabel.text = message
    }
}
