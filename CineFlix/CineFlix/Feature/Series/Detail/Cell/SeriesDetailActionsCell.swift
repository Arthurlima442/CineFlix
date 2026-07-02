//
//  SeriesDetailActionsCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 02/07/2026.
//

import UIKit

protocol SeriesDetailActionsCellDelegate: AnyObject {
    func playButtonTapped()
    func favoriteButtonTapped()
    func shareButtonTapped()
}

class SeriesDetailActionsCell: UITableViewCell {
    
    static let identifier = "SeriesDetailActionsCell"
    
    weak var delegate: SeriesDetailActionsCellDelegate?
    
    private let buttonsStackView = UIStackView()
    private let playButton = UIButton()
    private let favoriteButton = UIButton()
    private let shareButton = UIButton()
    
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
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 12
        buttonsStackView.distribution = .fillEqually
        contentView.addSubview(buttonsStackView)
        
        setupButton(playButton, title: "▶ Assistir", backgroundColor: .red, selector: #selector(playTapped))
        buttonsStackView.addArrangedSubview(playButton)
        
        setupButton(favoriteButton, title: "♡ Favorito", backgroundColor: .darkGray, selector: #selector(favoriteTapped))
        buttonsStackView.addArrangedSubview(favoriteButton)
        
        setupButton(shareButton, title: "⎙ Compartilhar", backgroundColor: .darkGray, selector: #selector(shareTapped))
        buttonsStackView.addArrangedSubview(shareButton)
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupButton(_ button: UIButton, title: String, backgroundColor: UIColor, selector: Selector) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: selector, for: .touchUpInside)
    }
    
    @objc private func playTapped() {
        delegate?.playButtonTapped()
    }
    
    @objc private func favoriteTapped() {
        delegate?.favoriteButtonTapped()
    }
    
    @objc private func shareTapped() {
        delegate?.shareButtonTapped()
    }
}
