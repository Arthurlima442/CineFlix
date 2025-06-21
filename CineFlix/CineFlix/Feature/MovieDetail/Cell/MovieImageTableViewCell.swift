//
//  MovieImageTableViewCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 21/06/2025.
//

import UIKit

class MovieImageTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: MovieImageTableViewCell.self)
    
    lazy var coverMovieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "coverPredador")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addElements()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addElements() {
        //  contentView.addSubview(suaView)
        contentView.addSubview(coverMovieImageView)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            coverMovieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverMovieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverMovieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverMovieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            coverMovieImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
