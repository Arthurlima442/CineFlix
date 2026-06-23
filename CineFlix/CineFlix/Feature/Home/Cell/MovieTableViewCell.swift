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
        iv.layer.cornerRadius = 15
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .white
        return iv
    }()
    
    lazy var nameMovieLabel: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 19, weight: .semibold)
        name.textColor = .white
        name.numberOfLines = 2
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var launchMovieLabel: UILabel = {
        let launch = UILabel()
        launch.font = .systemFont(ofSize: 17, weight: .semibold)
        launch.textColor = .white
        launch.translatesAutoresizingMaskIntoConstraints = false
        return launch
    }()
    
    lazy var genreMovieLabel: UILabel = {
        let genre = UILabel()
        genre.font = .systemFont(ofSize: 17, weight: .semibold)
        genre.textColor = .white
        genre.numberOfLines = 2
        genre.translatesAutoresizingMaskIntoConstraints = false
       return genre
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
        contentView.addSubview(genreMovieLabel)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            movieImageView.heightAnchor.constraint(equalToConstant: 160),
            movieImageView.widthAnchor.constraint(equalToConstant: 140),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameMovieLabel.topAnchor.constraint(equalTo: movieImageView.topAnchor, constant: 10),
            nameMovieLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            nameMovieLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            launchMovieLabel.topAnchor.constraint(equalTo: nameMovieLabel.bottomAnchor, constant: 10),
            launchMovieLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            launchMovieLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            genreMovieLabel.topAnchor.constraint(equalTo: launchMovieLabel.bottomAnchor, constant: 10),
            genreMovieLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            genreMovieLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),

        ])
    }
    
    func setupCell(movieData: MovieSummary) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w200\(movieData.posterPath ?? "")") else { return }
        movieImageView.loadImageFromURL(from: url, placeholder: UIImage(systemName: "hourglass"))
        nameMovieLabel.text = movieData.title ?? ""
        launchMovieLabel.text = Util.formatReleaseDate(movieData.releaseDate)
        let genreMap = Dictionary(uniqueKeysWithValues: MovieGenre.allCases.map { ($0.id, $0.rawValue) })
            genreMovieLabel.text = movieData.genreIDS?
                .compactMap { genreMap[$0] }
                .joined(separator: ", ")
                ?? "—"
    }
}
