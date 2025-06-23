//
//  MoviePosterCollectionViewCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 23/06/2025.
//

import UIKit

class MoviePosterCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: MoviePosterCollectionViewCell
        .self)
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .red
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func configure(with text: String) {
        label.text = text
    }
}


