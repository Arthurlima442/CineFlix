//
//  MovieImageTableViewCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 21/06/2025.
//

import UIKit

protocol MovieImageTableViewCellProtocol: AnyObject {
    func tappedBackButton()
}

class MovieImageTableViewCell: UITableViewCell {
    
    weak var delegate: MovieImageTableViewCellProtocol?
    
    static let identifier: String = String(describing: MovieImageTableViewCell.self)
    
    lazy var coverMovieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Ícone de seta (arrow.left)
        let image = UIImage(systemName:"arrow.left")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        // Estilo visual
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(tappedBackButton), for: .touchUpInside)
        return button
    }()
    
    @objc func tappedBackButton() {
        delegate?.tappedBackButton()
    }
    
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
        contentView.addSubview(coverMovieImageView)
        contentView.addSubview(backButton)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            coverMovieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverMovieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverMovieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverMovieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            coverMovieImageView.heightAnchor.constraint(equalToConstant: 400),
            
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
    }
    
    func setupCell(movieData: MovieDetail) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w400\(movieData.posterPath ?? "")") else { return }
        coverMovieImageView.loadImageFromURL(from: url, placeholder: UIImage(systemName: "star"))
    }
}
