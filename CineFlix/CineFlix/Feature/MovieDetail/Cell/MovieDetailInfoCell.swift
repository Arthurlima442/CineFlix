//
//  MovieDetailInfoCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 02/07/2026.
//

import UIKit

class MovieDetailInfoCell: UITableViewCell {
    
    static let identifier = "MovieDetailInfoCell"
    
    private let containerView = UIView()
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .black
        selectionStyle = .none
        
        // Container
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        
        // Stack View
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    private func addInfoRow(title: String, value: String) {
        let rowView = UIView()
        rowView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .lightGray
        titleLabel.text = title
        rowView.addSubview(titleLabel)
        
        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = .systemFont(ofSize: 15, weight: .regular)
        valueLabel.textColor = .white
        valueLabel.numberOfLines = 0
        valueLabel.text = value
        rowView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: rowView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: rowView.bottomAnchor)
        ])
        
        stackView.addArrangedSubview(rowView)
    }
    
    func configure(with movie: MovieDetail) {
        // Limpar views anteriores
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Data de Lançamento
        addInfoRow(title: "Data de Lançamento", value: Util.formatReleaseDate(movie.releaseDate))
        
        // Orçamento
        if let budget = movie.budget, budget > 0 {
            let budgetFormatted = String(format: "$%.2f M", Double(budget) / 1_000_000)
            addInfoRow(title: "Orçamento", value: budgetFormatted)
        }
        
        // Receita
        if let revenue = movie.revenue, revenue > 0 {
            let revenueFormatted = String(format: "$%.2f M", Double(revenue) / 1_000_000)
            addInfoRow(title: "Receita", value: revenueFormatted)
        }
        
        // Status
        addInfoRow(title: "Status", value: movie.status)
        
        // Homepage
        if let homepage = movie.homepage, !homepage.isEmpty {
            addInfoRow(title: "Homepage", value: homepage)
        }
        
        // Produtoras
        let companies = movie.productionCompanies.map { $0.name }.joined(separator: ", ")
        if !companies.isEmpty {
            addInfoRow(title: "Produtoras", value: companies)
        }
    }
}
