//
//  MovieDetailSynopsisCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 02/07/2026.
//

import UIKit

class MovieDetailSynopsisCell: UITableViewCell {
    
    static let identifier = "MovieDetailSynopsisCell"
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let synopsisLabel = UILabel()
    private let expandButton = UIButton()
    
    private var isExpanded = false
    
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
        contentView.addSubview(containerView)
        
        // Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.text = "Sinopse"
        containerView.addSubview(titleLabel)
        
        // Synopsis Text
        synopsisLabel.translatesAutoresizingMaskIntoConstraints = false
        synopsisLabel.font = .systemFont(ofSize: 15, weight: .regular)
        synopsisLabel.textColor = .lightGray
        synopsisLabel.numberOfLines = 3
        synopsisLabel.lineBreakMode = .byTruncatingTail
        containerView.addSubview(synopsisLabel)
        
        // Expand Button
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        expandButton.setTitle("Leia mais", for: .normal)
        expandButton.setTitleColor(.red, for: .normal)
        expandButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        expandButton.addTarget(self, action: #selector(expandTapped), for: .touchUpInside)
        containerView.addSubview(expandButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            synopsisLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            synopsisLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            synopsisLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            expandButton.topAnchor.constraint(equalTo: synopsisLabel.bottomAnchor, constant: 8),
            expandButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            expandButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    @objc private func expandTapped() {
        isExpanded = !isExpanded
        synopsisLabel.numberOfLines = isExpanded ? 0 : 3
        expandButton.setTitle(isExpanded ? "Leia menos" : "Leia mais", for: .normal)
    }
    
    func configure(with synopsis: String) {
        synopsisLabel.text = synopsis
    }
}
