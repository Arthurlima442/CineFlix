//
//  MovieInformationTableViewCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 21/06/2025.
//

import UIKit

class MovieInformationTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: MovieInformationTableViewCell.self)
    
    lazy var movieNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var launchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.text = "Launch in:"
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var dateLaunchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Duration:"
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    lazy var durationMovieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    lazy var assessmentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.text = "Avaliação:"
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var averageVoteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var synopsisLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.text = "Synopsis:"
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var synopsisMovieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .white
        return label
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
        //  contentView.addSubview(suaView)
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(durationMovieLabel)
        contentView.addSubview(launchLabel)
        contentView.addSubview(dateLaunchLabel)
        contentView.addSubview(assessmentLabel)
        contentView.addSubview(averageVoteLabel)
        contentView.addSubview(synopsisLabel)
        contentView.addSubview(synopsisMovieLabel)
    }
    
    // colocar no ultimo elemento mais proximo da borda inferior
    // .bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
    func configConstraints() {
        NSLayoutConstraint.activate([
            movieNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            movieNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            launchLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 20),
            launchLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            dateLaunchLabel.topAnchor.constraint(equalTo: launchLabel.bottomAnchor, constant: 5),
            dateLaunchLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            assessmentLabel.topAnchor.constraint(equalTo: dateLaunchLabel.bottomAnchor, constant: 20),
            assessmentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            averageVoteLabel.topAnchor.constraint(equalTo: assessmentLabel.bottomAnchor, constant: 5),
            averageVoteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            durationLabel.topAnchor.constraint(equalTo: averageVoteLabel.bottomAnchor, constant: 20),
            durationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            durationMovieLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 5),
            durationMovieLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            
            synopsisLabel.topAnchor.constraint(equalTo: durationMovieLabel.bottomAnchor, constant: 20),
            synopsisLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            synopsisMovieLabel.topAnchor.constraint(equalTo: synopsisLabel.bottomAnchor, constant: 5),
            synopsisMovieLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            synopsisMovieLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            synopsisMovieLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func setupCell(movie: MovieDetail) {
        movieNameLabel.text = movie.title
        durationMovieLabel.text = String("\(movie.runtime ?? 0) Minutos")
        dateLaunchLabel.text = Util.formatReleaseDate(movie.releaseDate)
        averageVoteLabel.text = String(movie.voteAverage)
        synopsisMovieLabel.text = movie.overview
    }
}
