//
//  emptyTableViewCell.swift
//  Movie
//
//  Created by Arthur Lima on 26/07/2025.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: EmptyTableViewCell.self)
    
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
            emptyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    func setupCell(message: String) {
        emptyLabel.text = message
    }
}
