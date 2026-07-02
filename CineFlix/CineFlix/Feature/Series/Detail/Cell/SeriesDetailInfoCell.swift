//
//  SeriesDetailInfoCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 02/07/2026.
//

import UIKit

class SeriesDetailInfoCell: UITableViewCell {
    
    static let identifier = "SeriesDetailInfoCell"
    
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
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        
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
    
    func configure(with series: SeriesDetail) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Primeira Data de Ar
        addInfoRow(title: "Estreia", value: Util.formatReleaseDate(series.firstAirDate))
        
        // Última Data de Ar
        if let lastAirDate = series.lastAirDate {
            addInfoRow(title: "Última Exibição", value: Util.formatReleaseDate(lastAirDate))
        }
        
        // Status
        addInfoRow(title: "Status", value: series.status)
        
        // Redes de Transmissão
        let networks = series.networks.map { $0.name }.joined(separator: ", ")
        if !networks.isEmpty {
            addInfoRow(title: "Redes", value: networks)
        }
    }
}
