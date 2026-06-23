// filepath: ErrorSeriesTableViewCell.swift
//
//  ErrorSeriesTableViewCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 10/01/2025.
//

import UIKit

class ErrorSeriesTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: ErrorSeriesTableViewCell.self)
    
    lazy var errorLabel: UILabel = {
        let error = UILabel()
        error.font = .systemFont(ofSize: 20, weight: .semibold)
        error.textColor = .white
        error.textAlignment = .center
        error.numberOfLines = 0
        error.translatesAutoresizingMaskIntoConstraints = false
        return error
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
        contentView.addSubview(errorLabel)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            errorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    func setupCell(message: String) {
        errorLabel.text = message
    }
}
