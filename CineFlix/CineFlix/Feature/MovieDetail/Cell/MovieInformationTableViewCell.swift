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
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var ageRangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    lazy var launchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.text = "Launch in:"
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var dateLaunchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var duratioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.text = "Duration:"
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var duratioMovieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var synopsisLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.text = "Synopsis:"
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var synopsisMovieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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
        contentView.addSubview(ageRangeLabel)
        contentView.addSubview(launchLabel)
        contentView.addSubview(dateLaunchLabel)
        contentView.addSubview(duratioLabel)
        contentView.addSubview(duratioMovieLabel)
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
            
            ageRangeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            ageRangeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            launchLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 20),
            launchLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            dateLaunchLabel.topAnchor.constraint(equalTo: launchLabel.bottomAnchor, constant: 5),
            dateLaunchLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            duratioLabel.topAnchor.constraint(equalTo: dateLaunchLabel.bottomAnchor, constant: 20),
            duratioLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            duratioMovieLabel.topAnchor.constraint(equalTo: duratioLabel.bottomAnchor, constant: 5),
            duratioMovieLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            synopsisLabel.topAnchor.constraint(equalTo: duratioMovieLabel.bottomAnchor, constant: 20),
            synopsisLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            synopsisMovieLabel.topAnchor.constraint(equalTo: synopsisLabel.bottomAnchor, constant: 5),
            synopsisMovieLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            synopsisMovieLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            synopsisMovieLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func setupCell(movie: Movie) {
        movieNameLabel.text = movie.title
        ageRangeLabel.text = String(movie.ageClassification)
        dateLaunchLabel.text = movie.launch
        duratioMovieLabel.text = movie.duration
        synopsisMovieLabel.text = movie.synopsis
    }
}
