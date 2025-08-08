//
//  MovieTableViewCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 08/08/2025.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: MovieTableViewCell.self)
    
    lazy var movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .white
        return iv
    }()
    
    lazy var nameMovieLabel: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 20, weight: .semibold)
        name.textColor = .white
        name.numberOfLines = 2
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var launchMovieLabel: UILabel = {
        let launch = UILabel()
        launch.font = .systemFont(ofSize: 20, weight: .semibold)
        launch.textColor = .white
        launch.translatesAutoresizingMaskIntoConstraints = false
        return launch
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
        contentView.addSubview(movieImageView)
        contentView.addSubview(nameMovieLabel)
        contentView.addSubview(launchMovieLabel)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            movieImageView.heightAnchor.constraint(equalToConstant: 120),
            movieImageView.widthAnchor.constraint(equalToConstant: 100),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameMovieLabel.topAnchor.constraint(equalTo: movieImageView.topAnchor, constant: 14),
            nameMovieLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            nameMovieLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            launchMovieLabel.topAnchor.constraint(equalTo: nameMovieLabel.bottomAnchor, constant: 10),
            launchMovieLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            launchMovieLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
        ])
    }
    
    func setupCell(movieData: MovieSummary) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w200\(movieData.posterPath ?? "")") else { return }
        movieImageView.loadImageFromURL(from: url, placeholder: UIImage(systemName: "hourglass"))
        nameMovieLabel.text = movieData.title ?? ""
        launchMovieLabel.text = Util.formatReleaseDate(movieData.releaseDate)
    }
}
