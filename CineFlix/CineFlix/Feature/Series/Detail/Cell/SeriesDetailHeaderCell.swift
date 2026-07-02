//
//  SeriesDetailHeaderCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 02/07/2026.
//

import UIKit

class SeriesDetailHeaderCell: UITableViewCell {
    
    static let identifier = "SeriesDetailHeaderCell"
    
    // MARK: - Views
    private let backdropImageView = UIImageView()
    private let gradientView = UIView()
    private let containerView = UIView()
    private let backdropContainer = UIView()
    
    private let posterImageView = UIImageView()
    private let infoStackView = UIStackView()
    
    private let titleLabel = UILabel()
    private let ratingContainer = UIView()
    private let ratingLabel = UILabel()
    private let voteCountLabel = UILabel()
    private let yearLabel = UILabel()
    private let seasonsEpisodesLabel = UILabel()
    private let genresLabel = UILabel()
    
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
        
        setupBackdropSection()
        setupPosterSection()
    }
    
    private func setupBackdropSection() {
        backdropContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backdropContainer)
        
        backdropImageView.translatesAutoresizingMaskIntoConstraints = false
        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.clipsToBounds = true
        backdropContainer.addSubview(backdropImageView)
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        backdropContainer.addSubview(gradientView)
        
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.black.withAlphaComponent(0.3).cgColor,
            UIColor.black.withAlphaComponent(0.8).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradientView.layer.addSublayer(gradient)
        
        NSLayoutConstraint.activate([
            backdropContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            backdropContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backdropContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backdropContainer.heightAnchor.constraint(equalToConstant: 260),
            
            backdropImageView.topAnchor.constraint(equalTo: backdropContainer.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: backdropContainer.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: backdropContainer.trailingAnchor),
            backdropImageView.bottomAnchor.constraint(equalTo: backdropContainer.bottomAnchor),
            
            gradientView.topAnchor.constraint(equalTo: backdropContainer.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: backdropContainer.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: backdropContainer.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: backdropContainer.bottomAnchor)
        ])
        
        DispatchQueue.main.async {
            gradient.frame = self.gradientView.bounds
        }
    }
    
    private func setupPosterSection() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .black
        contentView.addSubview(containerView)
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        containerView.addSubview(posterImageView)
        
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.spacing = 6
        infoStackView.alignment = .fill
        infoStackView.distribution = .equalSpacing
        containerView.addSubview(infoStackView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        infoStackView.addArrangedSubview(titleLabel)
        
        ratingContainer.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.addArrangedSubview(ratingContainer)
        
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        ratingLabel.textColor = .systemYellow
        ratingLabel.text = "⭐ "
        ratingContainer.addSubview(ratingLabel)
        
        voteCountLabel.translatesAutoresizingMaskIntoConstraints = false
        voteCountLabel.font = .systemFont(ofSize: 15, weight: .regular)
        voteCountLabel.textColor = .lightGray
        ratingContainer.addSubview(voteCountLabel)
        
        NSLayoutConstraint.activate([
            ratingLabel.leadingAnchor.constraint(equalTo: ratingContainer.leadingAnchor),
            ratingLabel.topAnchor.constraint(equalTo: ratingContainer.topAnchor),
            ratingLabel.bottomAnchor.constraint(equalTo: ratingContainer.bottomAnchor),
            
            voteCountLabel.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 4),
            voteCountLabel.topAnchor.constraint(equalTo: ratingContainer.topAnchor),
            voteCountLabel.bottomAnchor.constraint(equalTo: ratingContainer.bottomAnchor)
        ])
        
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.font = .systemFont(ofSize: 15, weight: .regular)
        yearLabel.textColor = .lightGray
        infoStackView.addArrangedSubview(yearLabel)
        
        seasonsEpisodesLabel.translatesAutoresizingMaskIntoConstraints = false
        seasonsEpisodesLabel.font = .systemFont(ofSize: 15, weight: .regular)
        seasonsEpisodesLabel.textColor = .lightGray
        infoStackView.addArrangedSubview(seasonsEpisodesLabel)
        
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        genresLabel.font = .systemFont(ofSize: 15, weight: .regular)
        genresLabel.textColor = .lightGray
        genresLabel.numberOfLines = 2
        infoStackView.addArrangedSubview(genresLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: backdropContainer.bottomAnchor, constant: -60),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            posterImageView.widthAnchor.constraint(equalToConstant: 130),
            posterImageView.heightAnchor.constraint(equalToConstant: 195),
            posterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            infoStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            infoStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            infoStackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
            
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with series: SeriesDetail) {
        // Backdrop
        if let backdropPath = series.backdropPath,
           let backdropURL = URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)") {
            backdropImageView.loadImageFromURL(from: backdropURL, placeholder: nil)
        }
        
        // Poster
        if let posterPath = series.posterPath,
           let posterURL = URL(string: "https://image.tmdb.org/t/p/w342\(posterPath)") {
            posterImageView.loadImageFromURL(from: posterURL, placeholder: nil)
        }
        
        // Info
        titleLabel.text = series.name
        
        let rating = String(format: "%.1f", series.voteAverage)
        ratingLabel.text = "⭐ \(rating)/10"
        
        let year = series.firstAirDate.prefix(4)
        yearLabel.text = "Desde \(year)"
        
        seasonsEpisodesLabel.text = "\(series.numberOfSeasons) Temporadas • \(series.numberOfEpisodes) Episódios"
        
        let genres = series.genres.map { $0.name }.joined(separator: ", ")
        genresLabel.text = genres
    }
}
