//
//  SeriesInformationTableViewCell.swift
//  CineFlix
//
//  Created by Arthur Lima on 10/01/2025.
//

import UIKit

class SeriesInformationTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: SeriesInformationTableViewCell.self)
    
    lazy var seriesNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    lazy var genresTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.text = "Gêneros:"
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var genresValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    lazy var firstAirDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.text = "Estreou em:"
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var dateFirstAirLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var seasonsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Temporadas:"
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    lazy var numberOfSeasonsLabel: UILabel = {
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
        label.text = "IMDb:"
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
        label.text = "Sinopse:"
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var synopsisSeriesLabel: UILabel = {
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
        contentView.addSubview(seriesNameLabel)
        contentView.addSubview(genresTitleLabel)
        contentView.addSubview(genresValueLabel)
        contentView.addSubview(seasonsLabel)
        contentView.addSubview(numberOfSeasonsLabel)
        contentView.addSubview(firstAirDateLabel)
        contentView.addSubview(dateFirstAirLabel)
        contentView.addSubview(assessmentLabel)
        contentView.addSubview(averageVoteLabel)
        contentView.addSubview(synopsisLabel)
        contentView.addSubview(synopsisSeriesLabel)
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            seriesNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            seriesNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            seriesNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            genresTitleLabel.topAnchor.constraint(equalTo: seriesNameLabel.bottomAnchor, constant: 20),
            genresTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            genresValueLabel.topAnchor.constraint(equalTo: genresTitleLabel.bottomAnchor, constant: 5),
            genresValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            genresValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            firstAirDateLabel.topAnchor.constraint(equalTo: genresValueLabel.bottomAnchor, constant: 20),
            firstAirDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            dateFirstAirLabel.topAnchor.constraint(equalTo: firstAirDateLabel.bottomAnchor, constant: 5),
            dateFirstAirLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            assessmentLabel.topAnchor.constraint(equalTo: dateFirstAirLabel.bottomAnchor, constant: 20),
            assessmentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            averageVoteLabel.topAnchor.constraint(equalTo: assessmentLabel.bottomAnchor, constant: 5),
            averageVoteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            seasonsLabel.topAnchor.constraint(equalTo: averageVoteLabel.bottomAnchor, constant: 20),
            seasonsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            numberOfSeasonsLabel.topAnchor.constraint(equalTo: seasonsLabel.bottomAnchor, constant: 5),
            numberOfSeasonsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            synopsisLabel.topAnchor.constraint(equalTo: numberOfSeasonsLabel.bottomAnchor, constant: 20),
            synopsisLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            synopsisSeriesLabel.topAnchor.constraint(equalTo: synopsisLabel.bottomAnchor, constant: 5),
            synopsisSeriesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            synopsisSeriesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            synopsisSeriesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func setupCell(series: SeriesDetail) {
        seriesNameLabel.text = series.name
        numberOfSeasonsLabel.text = String("\(series.numberOfSeasons)")
        dateFirstAirLabel.text = Util.formatReleaseDate(series.firstAirDate)
        averageVoteLabel.text = String("\(series.voteAverage) / 10.0")
        synopsisSeriesLabel.text = series.overview
        genresValueLabel.text = series.genres.map { $0.name }.joined(separator: ", ")
    }
}
